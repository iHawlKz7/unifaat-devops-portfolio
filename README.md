# Portfólio DevOps — UniFAAT 2026-2

![CI Pipeline - Aula 08](https://github.com/iHawlKz7/unifaat-devops-portfolio/actions/workflows/ci-aula08.yml/badge.svg)


**Aluno:** [Emar Cristian Silva Teruo ito]
**RA:** [6325192]  
**Disciplina:** DevOps — Centro Universitário UniFAAT  
**Professor:** Alexandre Tavares  
**Semestre:** 2026-2

## Sobre

Repositório de atividades e projetos da disciplina de DevOps.
Aqui documento minha evolução desde os fundamentos de Git e Docker até pipelines completas de CI/CD.

## Estrutura

## Como Executar (Aula 01)

```bash
cd aula-01/app
npm install
npm start

```bash
git add README.md
git commit -m "docs: adiciona instruções de execução ao README"
git push

## Aula 01 — Fundamentos de Git e Docker

## O que aprendi

- [Descreva 3-5 conceitos que aprendeu sobre Git]
1) Controle de versão por meio de commits
O Git registra alterações em pontos específicos chamados commits. Cada commit possui identificador, mensagem e autoria, permitindo acompanhar a evolução do projeto e consultar o histórico com git log.

2) Branches e merge
As branches permitem desenvolver funcionalidades de forma isolada, sem modificar imediatamente a branch principal. Depois que a funcionalidade está pronta, ela pode ser integrada à main por meio do git merge. O conteúdo também demonstra merge fast-forward e resolução de conflitos.

3)Repositório local e remoto
O projeto começa em um repositório local criado com git init. Em seguida, ele é conectado ao GitHub com git remote add origin, e os commits são publicados usando git push. Isso permite compartilhar, armazenar e colaborar no código.

- [Descreva 3-5 conceitos que aprendeu sobre Docker]
1)Diferença entre imagem e container
Uma imagem é o modelo imutável que contém a aplicação, suas dependências e configurações. O container é uma instância em execução dessa imagem. No laboratório, a imagem é construída com docker build e executada com docker run.

2)Containerização e isolamento do ambiente
O Docker fornece um ambiente isolado e reproduzível. A aplicação utiliza a mesma versão do Node.js e o mesmo sistema Alpine, independentemente das configurações existentes na máquina do desenvolvedor, evitando o problema de “funciona na minha máquina”.

3)Construção e gerenciamento de containers
O Dockerfile define como a imagem será construída, usando instruções como FROM, WORKDIR, COPY, RUN, EXPOSE e CMD. Depois, o container pode ser administrado com comandos como docker start, stop, logs, exec e rm.

## Comandos Git praticados

- [Liste os comandos Git que utilizou]
git init
git status
git add .
git commit -m "explicaçao da modificação"
git push origin main

## Comandos Docker praticados

- [Liste os comandos Docker que utilizou]
docker build -t portfolio-aula01:1.0 .
docker run -d --name portfolio-container -p 3000:3000 portfolio-aula01:1.0
docker ps
docker logs -f portfolio-container
docker stop portfolio-container

## Dificuldade encontradas
sem dificuldades 🥵

## Como executar este container

```bash
cd aula-01/app
docker build -t portfolio-aula01:1.0 .
docker run -d -p 3000:3000 portfolio-aula01:1.0
curl http://localhost:3000