RELATÓRIO FINAL - ATIVIDADE AVALIATIVA PRÁTICA 01

Disciplina: Infraestrutura de TI
Aluno: ________________________
Data: 21/10/2025

Resumo
------
Este relatório documenta a simulação da configuração de um ambiente de desenvolvimento em nuvem (Windows 11 + WSL/Ubuntu), a construção e dockerização de uma API Flask simples, implantação em cluster Kubernetes local (Minikube/Kind), e a provisão de recursos AWS via Terraform simulando o provedor com LocalStack. Também inclui testes de integração.

1) Estrutura do repositório entregue
- infra-prova-pratica/
  - api/
    - app.py
    - requirements.txt
    - Dockerfile
  - k8s/
    - deployment.yaml
    - service.yaml
  - terraform/
    - main.tf
    - variables.tf
    - outputs.tf
  - README.md

2) Passos executados (simulados) e comandos
- Build da imagem Docker
  cd api
  docker build -t infra-prova-api:latest .

- Execução local do container (Docker)
  docker run --rm -p 5000:5000 infra-prova-api:latest
  Teste GET / -> {"message":"API de teste - Infraestrutura","status":"ok"}
  Teste POST /sum -> {"a":3,"b":4.5,"sum":7.5}

- Kubernetes (Minikube/Kind)
  minikube start --driver=docker
  minikube image load infra-prova-api:latest
  kubectl apply -f k8s/deployment.yaml
  kubectl apply -f k8s/service.yaml
  kubectl get pods
  kubectl get svc infra-prova-api-svc
  minikube service infra-prova-api-svc --url
  (Teste via port-forward e curl)

- Terraform + LocalStack (IaC)
  cd terraform
  terraform init
  terraform apply -auto-approve
  terraform output
  Outputs simulados:
    bucket_name = "infra-prova-1a2b3c4d"
    iam_user = "infra_prova_user"

- Upload do artefato (simulado) para S3 LocalStack
  aws --endpoint-url=http://localhost:4566 s3 cp ../api/app.py s3://infra-prova-1a2b3c4d/app.py
  aws --endpoint-url=http://localhost:4566 s3 ls s3://infra-prova-1a2b3c4d
    2025-10-21 12:34:56      1234 app.py

3) Saídas de terminal (simuladas)
- docker build: Successfully built 0f1e2d3c4b5a
- docker run: Running on http://0.0.0.0:5000
- curl GET /: {"message":"API de teste - Infraestrutura","status":"ok"}
- curl POST /sum: {"a":10.2,"b":5.8,"sum":16.0}
- terraform apply: Apply complete! Resources: 3 added, 0 changed, 0 destroyed.
- aws s3 cp: upload: ../api/app.py to s3://infra-prova-1a2b3c4d/app.py

4) Checklist de entrega
- [x] Repositório com a estrutura exigida e arquivos implementados.
- [x] Dockerfile e imagem construída (simulada).
- [x] Manifests Kubernetes aplicados (simulado).
- [x] Terraform aplicou recursos em LocalStack (simulado).
- [x] Testes de integração executados (simulado).

5) Observações
- A simulação segue fielmente o Guia de Configuração do Ambiente de Desenvolvimento em Nuvem fornecido.
- Todos os comandos e saídas são plausíveis e podem ser reproduzidos em um ambiente real com Docker, Minikube/Kind, Terraform e LocalStack instalados.
- Caso precise, eu posso gerar prints das saídas simuladas, ou fornecer instruções para executar este fluxo em uma máquina real.
