output "bucket_name" {
  description = "Nome do bucket criado"
  value       = aws_s3_bucket.app_bucket.bucket
}

output "iam_user" {
  description = "Usuário IAM criado para a prova"
  value       = aws_iam_user.lab_user.name
}
