# Runbook — Rollback da TechNova API

## Quando usar

Use este procedimento quando um deploy causar erro, regressão ou indisponibilidade.

## 1. Identificar versão estável

```bash
aws ecr describe-images \
  --repository-name technova-api \
  --region us-east-1 \
  --query 'imageDetails[*].imageTags' \
  --output table
```

Escolha a tag SHA do último deploy estável.

## 2. Acessar a EC2

```bash
ssh -i ~/.ssh/technova-aula10 ubuntu@EC2_HOST
```

## 3. Login no ECR

```bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGISTRY="${ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"

aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin "$REGISTRY"
```

## 4. Executar rollback

```bash
IMAGE="${REGISTRY}/technova-api:SHA_ESTAVEL"

docker pull "$IMAGE"
docker stop technova-api 2>/dev/null || true
docker rm technova-api 2>/dev/null || true

docker run -d \
  --name technova-api \
  -p 3000:3000 \
  --restart unless-stopped \
  -e NODE_ENV=production \
  "$IMAGE"
```

## 5. Validar

```bash
docker ps --filter name=technova-api
curl -f http://localhost:3000/health
```

O endpoint deve responder HTTP 200 e `status: ok`.

## 6. Registrar incidente

Documente o SHA com problema, o SHA usado no rollback, a causa e a correção aplicada.
