variable "access_key_id" {
  type        = string
  sensitive   = true
}

variable "secret_access_key" {
  type        = string
  sensitive   = true
}

variable "vpc-cidr" {
    default = "10.0.0.0/16"
}