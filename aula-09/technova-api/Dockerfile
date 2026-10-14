# ============================================
# Estagio 1: Dependencias
# ============================================
FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production && npm cache clean --force


# ============================================
# Estagio 2: Runtime
# ============================================
FROM node:20-alpine AS runtime

LABEL org.opencontainers.image.source="https://github.com/iHawlKz7/unifaat-devops-portfolio"
LABEL org.opencontainers.image.description="TechNova API - Sistema de gestao de pedidos"

WORKDIR /app

RUN addgroup -g 1001 -S nodejs && \
    adduser -S technova -u 1001 -G nodejs

COPY --from=builder /app/node_modules ./node_modules

COPY . .

USER technova

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
