# Infraestrutura TechNova — Aula 04

**Aluno:** Emar Cristian  
**RA:** 6325192

Infraestrutura AWS desenvolvida com Terraform para o Trabalho de Fixação da Aula 04, utilizando arquitetura Multi-AZ.

## Arquitetura

    INTERNET
       |
    Internet Gateway
       |
    Public Route Table
    0.0.0.0/0
       |
       +-------------------------+
       |                         |
    Public Subnet 1          Public Subnet 2
    10.0.1.0/24              10.0.3.0/24
    AZ 1                     AZ 2
       |
    EC2 t2.micro
    TechNova API
    Porta 3000
       |
    Security Group API

    VPC 10.0.0.0/16

       |                         |
    Private Subnet 1         Private Subnet 2
    10.0.2.0/24              10.0.4.0/24
    AZ 1                     AZ 2

    Security Group DB
    PostgreSQL 5432

## Pré-requisitos

- AWS CLI
- Terraform
- AWS Academy Learner Lab
- Chave SSH `~/.ssh/technova-key`
- Git

## Como executar

Carregue as credenciais do AWS Academy:

    source aws-creds.sh
    aws sts get-caller-identity

Configure o repositório:

    export TF_VAR_repository_url="https://github.com/iHawlKz7/unifaat-devops-portfolio.git"
    export TF_VAR_repository_branch="feature/aula-04-vpc-ec2"

Inicialize, valide e aplique:

    terraform init
    terraform validate
    terraform plan
    terraform apply

## Como testar

Obtenha o IP público:

    export API_IP=$(terraform output -raw ec2_public_ip)

Teste a API:

    curl http://$API_IP:3000
    curl http://$API_IP:3000/health
    curl http://$API_IP:3000/orders

Teste SSH:

    ssh -i ~/.ssh/technova-key ec2-user@$API_IP

## Como destruir

    terraform destroy

## Decisões técnicas

### Multi-AZ

Foram utilizadas duas Availability Zones para melhorar a disponibilidade da infraestrutura e prepará-la para futura expansão com Load Balancer e Auto Scaling.

### Subnets públicas e privadas

As duas subnets públicas possuem acesso ao Internet Gateway e são destinadas aos recursos que precisam de acesso externo.

As duas subnets privadas não possuem rota direta para a internet e são destinadas a recursos internos, como bancos de dados.

### Security Groups

O Security Group da API permite SSH na porta 22 e acesso à aplicação Node.js na porta 3000.

O Security Group do banco permite PostgreSQL na porta 5432 somente para a rede interna `10.0.0.0/16`.

### Instance Profile e AWS Academy

O código contém a implementação de uma IAM Role com a política `AmazonS3ReadOnlyAccess` e um Instance Profile.

Como o AWS Academy Learner Lab bloqueia a criação de novas IAM Roles, a execução no Academy utiliza o `LabInstanceProfile` fornecido pelo ambiente.

## Recursos criados

| Recurso | Função |
|---|---|
| VPC | Rede principal da TechNova |
| 2 subnets públicas | Recursos com acesso externo |
| 2 subnets privadas | Recursos internos |
| Internet Gateway | Comunicação com a internet |
| Route Table pública | Roteamento das subnets públicas |
| Security Group API | Firewall da aplicação |
| Security Group DB | Firewall do banco |
| EC2 t2.micro | Servidor da TechNova API |
| Key Pair | Acesso SSH |
| Instance Profile | Permissões AWS da instância |
