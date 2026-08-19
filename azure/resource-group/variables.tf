variable "name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment (dev/qa/prod)"
  type        = string
}

variable "tags" {
  description = "Tags for RG"
  type        = map(string)
  default     = {}
}

variable "ticket" {
  type = string
}
