const fs = require('fs');

const DIFF_FILE = process.env.DIFF_FILE || '/tmp/pr-diff.txt';
const RESULT_FILE = '/tmp/ai-review-result.md';

const SEVERITY = {
  CRITICAL: '🔴 CRITICAL',
  WARNING: '🟡 WARNING',
  INFO: '🔵 INFO'
};

const RULES = [
  {
    pattern: /(password|passwd|secret|api[_-]?key|apikey|token)\s*[:=]\s*['"][^'"]+['"]/i,
    message: 'Possivel secret ou credencial hardcoded',
    severity: SEVERITY.CRITICAL
  },
  {
    pattern: /\beval\s*\(/i,
    message: 'Uso de eval() pode permitir code injection',
    severity: SEVERITY.CRITICAL
  },
  {
    pattern: /\b(SELECT|INSERT|UPDATE|DELETE)\b.*\+/i,
    message: 'Possivel SQL Injection por concatenacao de valores',
    severity: SEVERITY.CRITICAL
  },
  {
    pattern: /\bexec\s*\(\s*['"`].*\$\{/i,
    message: 'Possivel command injection',
    severity: SEVERITY.CRITICAL
  },
  {
    pattern: /\bchmod\s+777\b/i,
    message: 'Permissao 777 excessivamente aberta',
    severity: SEVERITY.CRITICAL
  },
  {
    pattern: /console\.(log|debug|info)\s*\(/i,
    message: 'Console em codigo de producao; avaliar uso de logger',
    severity: SEVERITY.WARNING
  },
  {
    pattern: /catch\s*\(\s*\w*\s*\)\s*\{\s*\}/i,
    message: 'Catch vazio pode esconder erros',
    severity: SEVERITY.WARNING
  },
  {
    pattern: /0\.0\.0\.0|INADDR_ANY/i,
    message: 'Binding em todas as interfaces; verificar se e intencional',
    severity: SEVERITY.WARNING
  },
  {
    pattern: /\b(TODO|FIXME|HACK|XXX)\b/i,
    message: 'Pendencia de codigo encontrada',
    severity: SEVERITY.INFO
  }
];

function sanitize(value) {
  return String(value)
    .replace(/\|/g, '\\|')
    .replace(/`/g, "'")
    .trim()
    .substring(0, 100);
}

function analyzeDiff(diffContent) {
  const findings = [];
  const lines = diffContent.split('\n');

  let currentFile = '';
  let sourceLine = 0;

  for (const line of lines) {
    if (line.startsWith('+++ b/')) {
      currentFile = line.substring(6);
      sourceLine = 0;
      continue;
    }

    const hunkMatch = line.match(/^@@.*\+(\d+)(?:,\d+)?\s@@/);

    if (hunkMatch) {
      sourceLine = Number(hunkMatch[1]);
      continue;
    }

    if (line.startsWith('+') && !line.startsWith('+++')) {
      const addedCode = line.substring(1);

      // Evita que o analisador detecte as proprias regex como problemas.
      if (currentFile === '.github/scripts/ai-review.js') {
        sourceLine += 1;
        continue;
      }

      // package-lock e arquivos gerados nao precisam de review semantico.
      if (currentFile.endsWith('package-lock.json')) {
        sourceLine += 1;
        continue;
      }

      for (const rule of RULES) {
        if (rule.pattern.test(addedCode)) {
          findings.push({
            file: currentFile || 'arquivo desconhecido',
            line: sourceLine,
            code: sanitize(addedCode),
            message: rule.message,
            severity: rule.severity
          });
        }
      }

      sourceLine += 1;
      continue;
    }

    if (!line.startsWith('-')) {
      sourceLine += 1;
    }
  }

  return findings;
}

function buildReport(findings) {
  const marker = '<!-- technova-ai-review -->';

  if (findings.length === 0) {
    return `${marker}
## 🤖 AI Code Review — TechNova

✅ **Nenhum problema foi encontrado nas linhas adicionadas neste PR.**

O review automatizado verificou padrões de segurança e qualidade.

> Este review complementa, mas não substitui, a revisão humana.
`;
  }

  const critical = findings.filter(
    item => item.severity === SEVERITY.CRITICAL
  ).length;

  const warning = findings.filter(
    item => item.severity === SEVERITY.WARNING
  ).length;

  const info = findings.filter(
    item => item.severity === SEVERITY.INFO
  ).length;

  let report = `${marker}
## 🤖 AI Code Review — TechNova

Foram encontrados **${findings.length} achados**.

| Severidade | Quantidade |
|---|---:|
| 🔴 CRITICAL | ${critical} |
| 🟡 WARNING | ${warning} |
| 🔵 INFO | ${info} |

### Achados

| Severidade | Arquivo | Linha | Descrição | Código |
|---|---|---:|---|---|
`;

  for (const finding of findings) {
    report += `| ${finding.severity} | \`${sanitize(finding.file)}\` | ${finding.line || '-'} | ${sanitize(finding.message)} | \`${sanitize(finding.code)}\` |\n`;
  }

  report += `
### Quality Gate

`;

  if (critical > 0) {
    report += `⛔ **PR BLOQUEADO:** existem achados CRITICAL.

Corrija os problemas críticos e faça um novo push.
`;
  } else {
    report += `✅ **Quality gate aprovado:** não existem achados CRITICAL.

WARNING e INFO são recomendações e não bloqueiam o PR.
`;
  }

  report += `
> A análise automatizada complementa o review humano e pode apresentar falsos positivos ou falsos negativos.
`;

  return report;
}

if (!fs.existsSync(DIFF_FILE)) {
  console.error(`Arquivo de diff nao encontrado: ${DIFF_FILE}`);
  process.exit(2);
}

const diff = fs.readFileSync(DIFF_FILE, 'utf8');
const findings = analyzeDiff(diff);
const report = buildReport(findings);

fs.writeFileSync(RESULT_FILE, report);

console.log(report);

const hasCritical = findings.some(
  finding => finding.severity === SEVERITY.CRITICAL
);

if (hasCritical) {
  console.log('\nPR BLOQUEADO: achados CRITICAL encontrados.');
  process.exit(1);
}

console.log('\nQuality gate aprovado.');
