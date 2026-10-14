# Aula 09 — Docker Registry + IA no CI/CD

**Aluno:** Emar Cristian Silva Teruo Ito
**RA:** 6325192
**GitHub:** iHawlKz7

## Objetivo

Evoluir a TechNova API com:

- lint;
- testes automatizados;
- build Docker;
- publicação no GitHub Container Registry;
- tags SHA, latest e SemVer;
- AI Review em Pull Requests;
- quality gate para achados críticos.

## Estrutura

```text
aula-09/
├── technova-api/
│   ├── __tests__/
│   ├── Dockerfile
│   ├── .dockerignore
│   ├── .eslintrc.json
│   ├── package.json
│   ├── package-lock.json
│   └── server.js
├── screenshots/
├── ia-cicd-analise.md
└── README.md

.github/
├── workflows/
│   ├── ci.yml
│   └── ai-review.yml
└── scripts/
    └── ai-review.js
```

## Executar localmente

```bash
cd aula-09/technova-api
npm ci
npm run lint
npm run test:ci
npm run build
npm start
```

Health check:

```text
GET http://localhost:3000/health
```

## Docker

```bash
docker build -t technova-api:aula09 aula-09/technova-api
docker run --rm -p 3000:3000 technova-api:aula09
```

## GitHub Container Registry

As imagens são publicadas em:

```text
ghcr.io/iHawlKz7/technova-api
```

Tags utilizadas:

```text
sha-XXXXXXX
latest
1.2.3
1.2
1
```

## Fluxo

```text
código
  ↓
lint + testes
  ↓
Docker build
  ↓
ghcr.io
  ↓
imagem versionada
  ↓
deploy nas próximas aulas
```

Pull Requests também passam pelo AI Review e pelo quality gate.
