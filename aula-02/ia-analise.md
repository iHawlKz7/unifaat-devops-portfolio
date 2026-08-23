# Análise do Uso de IA — Aula 02 TF

## Prompt Utilizado

Crie um docker-compose.yml para uma aplicação Node.js 20 com Express que usa PostgreSQL 15 como banco de dados e Redis 7 como cache. A API roda na porta 3000. O PostgreSQL precisa de volume nomeado para persistência. Todos os serviços devem estar na mesma rede bridge customizada. Use variáveis de ambiente com interpolação de arquivo .env. Adicione healthchecks, depends_on com condition e restart policy unless-stopped.

## Output Original da IA

A IA propôs uma estrutura inicial com três serviços:

- API Node.js construída pelo Dockerfile local;
- PostgreSQL 15 Alpine;
- Redis 7 Alpine;
- rede bridge customizada;
- volume nomeado para persistência do PostgreSQL;
- variáveis de ambiente em arquivo `.env`;
- healthchecks e `depends_on`.

## Alterações que Fiz Manualmente

| O que mudei | Por quê |
|---|---|
| Usei nomes exclusivos nos containers (`technova-aula02-*`) | Já existiam containers dos laboratórios anteriores usando os nomes padrão da TechNova. |
| Expus a API pela porta 3001 do computador, direcionada à porta 3000 do container | A porta 3000 já estava ocupada por outro laboratório. A API continua executando na porta 3000 internamente. |
| Não expus PostgreSQL e Redis ao computador | A API acessa ambos pela rede Docker, evitando conflito com as portas 5432 e 6379 usadas por outros ambientes. |
| Configurei todas as variáveis via `.env` | Evita credenciais hardcoded no `docker-compose.yml`. |
| Adicionei healthcheck à API | Permite verificar se a aplicação está respondendo no endpoint `/health`. |
| Mantive volumes nomeados para PostgreSQL e Redis | Garante persistência de dados ao recriar containers. |
| Validei o ambiente com `docker compose ps`, `/health` e endpoints de cache | Confirmei que API, banco e Redis estavam funcionando juntos. |

## O que a IA Acertou

- Sugeriu corretamente a arquitetura com API, PostgreSQL e Redis.
- Indicou o uso de imagens leves `postgres:15-alpine` e `redis:7-alpine`.
- Incluiu rede bridge personalizada, volumes, healthchecks e política de reinício.
- Usou `depends_on` com condição de healthcheck para iniciar a API após os serviços dependentes.

## O que a IA Errou ou Omitiu

- Não conhecia os containers já em execução dos laboratórios anteriores e, por isso, seria necessário ajustar nomes e portas.
- O ambiente precisou ser testado na prática para identificar conflitos de portas.
- Após alterar a senha do PostgreSQL no `.env`, foi necessário recriar o volume do banco, pois credenciais iniciais são persistidas pelo PostgreSQL.

## Minha Avaliação

- **Tempo economizado usando IA:** aproximadamente 30 minutos.
- **Tempo gasto validando e corrigindo:** aproximadamente 25 minutos.
- **Nota para o output da IA:** 8/10.
- **Usaria novamente para este tipo de tarefa?** Sim. A IA acelera a criação do rascunho e ajuda a lembrar boas práticas, mas é necessário validar os arquivos, testar os containers e adaptar a solução ao ambiente real.