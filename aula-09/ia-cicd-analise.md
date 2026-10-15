# Aula 09 — Docker Registry e IA no CI/CD

**Aluno:** Emar Cristian Silva Teruo Ito
**RA:** 6325192
**GitHub:** iHawlKz7

## Estratégia de tagging

A TechNova usa três tipos de tag:

- **SHA** (`sha-a1b2c3d`): liga cada imagem ao commit que a gerou e facilita rastreabilidade e rollback.
- **latest**: representa a versão mais recente da `main`; é útil por conveniência, mas não deve ser a única referência em produção porque é mutável.
- **Semantic Versioning** (`v1.2.3`): releases oficiais geram as tags `1.2.3`, `1.2` e `1`.

## Pipeline CI

O fluxo é:

```text
lint ─┐
      ├─> build-and-push
test ─┘
```

`build-and-push` só executa depois de `lint` e `test`.

Em Pull Requests, a imagem é construída para validação, mas não é publicada. O push para o GHCR ocorre somente em eventos `push` para a `main` ou para tags SemVer.

Registry:

```text
ghcr.io/iHawlKz7/technova-api
```

A autenticação usa `GITHUB_TOKEN`, sem necessidade de gravar PAT no repositório.

## AI Review

O workflow roda em Pull Requests nos eventos `opened`, `synchronize` e `reopened`.

Ele gera o diff entre a branch do PR e a branch base, analisa as linhas adicionadas e produz um relatório em Markdown.

Nesta aula a análise é determinística, por regras de pattern matching. A mesma arquitetura pode ser evoluída depois para um LLM, como AWS Bedrock.

## Padrões verificados

1. secrets ou credenciais hardcoded — **CRITICAL**
2. uso de `eval()` — **CRITICAL**
3. possível SQL Injection — **CRITICAL**
4. possível command injection — **CRITICAL**
5. `chmod 777` — **CRITICAL**
6. `console.log`, `console.debug` ou `console.info` — **WARNING**
7. `catch` vazio — **WARNING**
8. binding em `0.0.0.0` — **WARNING**
9. `TODO`, `FIXME`, `HACK` ou `XXX` — **INFO**

## Lógica da análise

Para cada linha adicionada no diff, o script compara o conteúdo com regras de segurança e qualidade.

Cada achado recebe arquivo, linha, descrição e severidade. O relatório é postado no PR.

O comentário anterior do bot é atualizado quando existe, evitando comentários duplicados.

## Quality Gate

| Severidade | Comportamento |
|---|---|
| CRITICAL | o script retorna `exit 1` e o check falha |
| WARNING | informa, mas não bloqueia |
| INFO | sugestão, sem bloquear |

A ideia é bloquear apenas problemas com risco alto, como exposição de credenciais ou execução de código não confiável.

## Quando confiar na automação

A automação funciona bem para verificações objetivas e repetitivas:

- busca por secrets;
- padrões de injection;
- chamadas perigosas;
- permissões inseguras;
- pendências textuais.

## Quando exigir review humano

O review humano continua necessário para:

- regras de negócio;
- decisões arquiteturais;
- impacto funcional;
- experiência do usuário;
- legibilidade e manutenção;
- mudanças que dependem do contexto completo do sistema.

## Limitações

**Falsos positivos:** uma expressão pode parecer perigosa para a regra, mesmo sendo segura no contexto real.

**Falsos negativos:** bugs complexos podem não corresponder a nenhum padrão cadastrado.

**Contexto limitado:** o mecanismo analisa principalmente o diff do PR.

**Pattern matching não é um LLM:** nesta aula a automação usa regras determinísticas. O desenho permite substituir ou complementar o motor por IA futuramente.

## Conclusão

CI, versionamento de imagens, GHCR e revisão automatizada tornam a entrega da TechNova mais reproduzível e rastreável.

As imagens geradas nesta aula servirão de base para as próximas aulas de deploy.
