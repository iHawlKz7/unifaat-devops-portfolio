# Aula 10 — Terraform Automatizado e CD Pipelines

Implementação de GitOps com Terraform e Continuous Deployment usando GitHub Actions, Amazon ECR e EC2 no AWS Academy Learner Lab.

## Infraestrutura

- VPC e subnet pública
- Internet Gateway e Route Table
- Security Group
- EC2 Ubuntu com Docker e AWS CLI
- backend remoto S3
- locking DynamoDB
- Amazon ECR `technova-api`

## Estrutura

- `terraform/`: infraestrutura
- `technova-api/`: aplicação
- `docs/runbook-rollback.md`: rollback
- `gitops-cd-analise.md`: análise
- `screenshots/`: evidências

## Workflows

Na raiz do portfólio:
- `.github/workflows/terraform-plan-aula10.yml`
- `.github/workflows/terraform-apply-aula10.yml`
- `.github/workflows/cd-aula10.yml`

## Fluxos

Terraform: `PR → Plan → Review → Merge → Apply`

Aplicação: `Lint → Test → Build → Amazon ECR → EC2 → Health Check`

## Secrets

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN`
- `AWS_ACCOUNT_ID`
- `EC2_HOST`
- `EC2_USERNAME`
- `EC2_SSH_KEY`

As credenciais AWS são temporárias e devem ser atualizadas quando a sessão do Learner Lab expirar.

## Evidências obrigatórias

- `screenshots/plan-pr-comment.png`
- `screenshots/apply-success.png`
- `screenshots/cd-pipeline-green.png`
- `screenshots/health-check-pass.png`
