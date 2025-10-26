variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Nome do bucket (deixe vazio para gerar automaticamente)"
  default     = ""
}

variable "localstack_s3_endpoint" {
  type    = string
  default = "http://localhost:4566"
}
