# infra-prova-pratica

## Estrutura
- api/: código da API Flask + Dockerfile
- k8s/: manifests Kubernetes (Deployment + Service)
- terraform/: código Terraform para criar S3 + IAM (configurado para LocalStack)
- README.md: este arquivo

---

## Instruções (fluxo simulado)

### 1) Build da imagem Docker
```bash
cd api
docker build -t infra-prova-api:latest .
```

### 2) Teste local (Docker)
```bash
docker run --rm -p 5000:5000 infra-prova-api:latest
# curl http://localhost:5000/
# curl -X POST http://localhost:5000/sum -H "Content-Type: application/json" -d '{"a":3,"b":4.5}'
```

### 3) Carregar imagem para Minikube / Kind
- Minikube:
```bash
minikube image load infra-prova-api:latest
minikube start --driver=docker
kubectl apply -f ../k8s/deployment.yaml
kubectl apply -f ../k8s/service.yaml
minikube service infra-prova-api-svc --url
```
- Kind:
```bash
kind load docker-image infra-prova-api:latest --name <cluster-name>
kubectl apply -f ../k8s/deployment.yaml
kubectl apply -f ../k8s/service.yaml
kubectl port-forward deployment/infra-prova-api 5000:5000
```

### 4) Terraform + LocalStack (IaC simulado)
- Inicie LocalStack (instalado localmente): `localstack start`
- Na pasta terraform:
```bash
terraform init
terraform apply -auto-approve
terraform output
```

### 5) Enviar artefato para o bucket (simulação com endpoint LocalStack)
```bash
aws --endpoint-url=http://localhost:4566 s3 cp ../api/app.py s3://<bucket_name>/app.py
```

### 6) Testes de integração (curl / Postman)
- GET:
```bash
curl http://localhost:5000/
# -> {"message":"API de teste - Infraestrutura","status":"ok"}
```
- POST /sum:
```bash
curl -X POST http://localhost:5000/sum -H "Content-Type: application/json" -d '{"a":3,"b":4.5}'
# -> {"a":3,"b":4.5,"sum":7.5}
```
