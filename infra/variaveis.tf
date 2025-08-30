variable "project_id" {
  description = "ID do projeto GCP"
  type        = string
}

variable "region" {
  description = "Região do GCP"
  type        = string
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
}

variable "credentials_file" {
  description = "Conta de Serviço"
  type        = string
}

variable "pfsense_image_name" {
  description = "Nome da Imagem pfSense no Storage Bucket"
  type        = string
}
