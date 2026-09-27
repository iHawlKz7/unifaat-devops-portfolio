# Aula 06 — Terraform Modules

**Aluno:** Emar Cristian  
**RA:** 6325192  
**Disciplina:** DevOps  
**Professor:** Alexandre Tavares

---

## Objetivo

Esta atividade demonstra a criação de uma infraestrutura AWS reutilizável e organizada utilizando módulos Terraform.

A solução foi dividida em módulos independentes para VPC, Security Group, EC2 e RDS, permitindo que a mesma infraestrutura seja reutilizada em diferentes ambientes.

Foram criados dois ambientes:

- dev
- staging

Cada ambiente utiliza os mesmos módulos, alterando apenas valores de configuração como CIDRs, nomes e banco de dados.

---

## Estrutura

    aula-06/
    ├── modules/
    │   ├── vpc/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   ├── security-group/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   ├── ec2/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   └── rds/
    │       ├── main.tf
    │       ├── variables.tf
    │       └── outputs.tf
    ├── environments/
    │   ├── dev/
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   ├── outputs.tf
    │   │   ├── providers.tf
    │   │   └── terraform.tfvars
    │   └── staging/
    │       ├── main.tf
    │       ├── variables.tf
    │       ├── outputs.tf
    │       ├── providers.tf
    │       └── terraform.tfvars
    └── .gitignore

---

## Arquitetura

A infraestrutura é composta por:

    VPC
     |
     +-- Subnets públicas
     |     |
     |     +-- EC2
     |
     +-- Subnets privadas
           |
           +-- RDS PostgreSQL

A VPC possui quatro subnets distribuídas entre duas zonas de disponibilidade.

O ambiente possui:

- 2 subnets públicas
- 2 subnets privadas
- Internet Gateway
- Route Table pública
- Security Group da EC2
- Security Group do RDS
- EC2
- RDS PostgreSQL

---

## Módulo VPC

O módulo VPC é responsável por criar:

- VPC
- Internet Gateway
- subnets públicas
- subnets privadas
- Route Table pública
- associações das subnets públicas

As subnets são criadas utilizando `for_each`, permitindo que a quantidade e configuração sejam definidas por um mapa.

### Inputs

- `vpc_cidr`
- `project_name`
- `environment`
- `subnets`

### Outputs

- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`

---

## Módulo Security Group

O módulo de Security Group foi criado de forma genérica.

As regras de entrada são fornecidas através da variável `ingress_rules`, permitindo reutilizar o mesmo módulo para diferentes tipos de acesso.

Foram criados dois Security Groups:

- Security Group da API
- Security Group do RDS

A API permite acesso pela porta 3000.

O RDS permite acesso pela porta 5432 somente a partir do Security Group da EC2.

### Inputs

- `name`
- `vpc_id`
- `ingress_rules`
- `environment`
- `project_name`

### Outputs

- `sg_id`

---

## Módulo EC2

O módulo EC2 cria uma instância utilizando parâmetros fornecidos pelo ambiente.

### Inputs

- `instance_name`
- `instance_type`
- `ami_id`
- `subnet_id`
- `security_group_ids`
- `key_name`
- `user_data`
- `environment`
- `project_name`

### Outputs

- `instance_id`
- `public_ip`
- `private_ip`

---

## Módulo RDS

O módulo RDS cria:

- DB Subnet Group
- instância PostgreSQL

O banco utiliza as subnets privadas da VPC.

Também foi configurado com:

- `publicly_accessible = false`
- `storage_encrypted = true`
- `skip_final_snapshot = true`

### Inputs

- `db_name`
- `db_username`
- `db_password`
- `subnet_ids`
- `security_group_ids`
- `instance_class`
- `environment`
- `project_name`

### Outputs

- `db_endpoint`
- `db_name`
- `db_port`

---

## Composição entre módulos

Os módulos foram conectados através de outputs e inputs.

Exemplos:

    module.vpc.vpc_id
        |
        v
    module.api_sg

    module.vpc.public_subnet_ids
        |
        v
    module.api_server

    module.vpc.private_subnet_ids
        |
        v
    module.database

    module.api_sg.sg_id
        |
        v
    module.rds_sg

    module.rds_sg.sg_id
        |
        v
    module.database

Dessa forma, os módulos permanecem independentes e reutilizáveis.

---

## Ambiente DEV

Configuração utilizada:

    VPC: 10.0.0.0/16

    Public subnet 1: 10.0.1.0/24
    Public subnet 2: 10.0.2.0/24

    Private subnet 1: 10.0.3.0/24
    Private subnet 2: 10.0.4.0/24

    EC2: t2.micro
    RDS: db.t3.micro
    Database: technova_dev

---

## Ambiente STAGING

Configuração utilizada:

    VPC: 10.1.0.0/16

    Public subnet 1: 10.1.1.0/24
    Public subnet 2: 10.1.2.0/24

    Private subnet 1: 10.1.3.0/24
    Private subnet 2: 10.1.4.0/24

    EC2: t2.micro
    RDS: db.t3.micro
    Database: technova_staging

---

## Pré-requisitos

- Terraform instalado
- AWS CLI instalada
- credenciais AWS configuradas
- acesso ao AWS Academy Learner Lab
- região `us-east-1`

---

## Validação DEV

    cd environments/dev

    terraform init
    terraform fmt -recursive
    terraform validate
    terraform plan

---

## Validação STAGING

    cd environments/staging

    terraform init
    terraform fmt -recursive
    terraform validate
    terraform plan

---

## Resultado da validação

Os ambientes DEV e STAGING foram validados com:

    terraform validate

Resultado:

    Success! The configuration is valid.

O `terraform plan` deve ser executado com credenciais AWS válidas do AWS Academy Learner Lab.

---

## Observações

A atividade utiliza módulos para evitar duplicação de código entre ambientes.

A infraestrutura de DEV e STAGING utiliza a mesma implementação de módulos, alterando apenas os parâmetros definidos em cada ambiente.

Nenhuma credencial AWS deve ser versionada no Git.
