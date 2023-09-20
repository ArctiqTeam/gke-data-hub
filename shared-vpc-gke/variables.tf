variable "billing_account_id" {
  description = "Billing account id used as default for new projects."
  type        = string
}

variable "prefix" {
  description = "Prefix used for resource names."
  type        = string
  validation {
    condition     = var.prefix != ""
    error_message = "Prefix cannot be empty."
  }
}

variable "project_services" {
  description = "Service APIs enabled by default in new projects."
  type        = list(string)
  default = [
    "container.googleapis.com",
    "stackdriver.googleapis.com",
  ]
}

variable "region" {
  description = "Region used."
  type        = string
  default     = "us-east1"
}

variable "root_node" {
  description = "Hierarchy node where projects will be created, 'organizations/org_id' or 'folders/folder_id'."
  type        = string
}

variable "domain" {
  description = "Domain used for the G Suite account."
  type        = string
  default     = "example.com"
}