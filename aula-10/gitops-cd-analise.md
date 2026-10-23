# Análise — GitOps e Continuous Deployment

## Fluxo GitOps

A infraestrutura da Aula 10 usa Git como fonte da verdade. Mudanças em Terraform são propostas por Pull Request. O workflow `terraform-plan-aula10.yml` executa `terraform init`, `terraform fmt -check`, `terraform validate` e `terraform plan`, publicando o resultado como comentário no PR.

Após revisão, o merge na branch `main` o representa a aprovação. O workflow `terraform-apply-aula10.yml` executa automaticamente `terraform apply -auto-approve`.

## Autenticação no AWS Academy Learner Lab

O Learner Lab fornece credenciais temporárias:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY@
- `AWS_SESSION_TOKEN`

Elas ficam em GitHub Secrets e são usadas por `aws-actions/configure-aws-credentials@v4`. As credenciais expiram com a sessão do laboratório e precisam ser atualizadas ao iniciar uma nova sessão.

Em produção, o ideal seria OIDC com uma IAM Role, evitando armazenar chaves. O Learner Lab não permite criar os recursos IAM/OIDC necessários.

## Pipeline de Continuous Deployment

O workflow `cd-aula10.yml` executa:

``lint → test → build-push → deploy → health check`

A aplicação é validada com ESLint e Jest. Depois, a imagem Docker é publicada no Amazon ECR com as tags `latest` e SHA do commit.

## Estratégia Recreate

O deploy segue:
1. login no Amazon ECR;
2. `docker pull`;
3. `docker stop`;
4. `docker rm`;
5. `docker run`;
6. health check.

Vantagens: simplicidade, baixo custo e fácil operação.
Desvantagens: pequeno downtime e necessidade de rollback em caso de falha.

## Continuous Delivery vs Continuous Deployment

Continuous Delivery automatiza o processo até deixar a versão pronta para produção, podendo manter aprovação manual. Continuous Deployment também automatiza a publicação em produção após a integração da mudança.

Nesta aula, o merge na `main` pode executar build, push no ECR, deploy na EC2 e health check automaticamente.

## Health Check

O pipeline verifica `http://EC2_HOST:3000/health`. Se a aplicação não responder com sucesso após as tentativas configuradas, o workflow falha.

## Rollback

As imagens recebem tags baseadas no SHA. Para rollback:
1. identificar uma versão estável;
2. acessar a EC2;
3. autenticar no ECR;
4. fazer pull da imagem anterior;
5. remover o container atual;
6. iniciar a versão anterior;
7. validar `/health`.

O login no ECR deve ocorrer antes do `docker pull`. O procedimento está detalhado em `docs/runbook-rollback.md`.

## Limitações e melhorias

Limitações atuais:
- credenciais temporárias do Learner Lab;
- SSH liberado para `0.0.0.0/0` no laboratório;
- uma única EC2;
- downtime do Recreate;
- rollback manual.

Melhorias para produção:
- OIDC;
- GitHub Environments;
- SSH restrito;
- Load Balancer;
- Blue-Green ou Canary;
- monitoramento e rollback automático.
