variable "project_ids" {
  type    = list(string)
  default = []
}

variable "dataset_id" {
  type    = string
  default = ""
}

variable "location" {
  type    = string
  default = ""
}

variable "service_account_name" {
  type    = string
  default = ""
}

variable "display_name" {
  type    = string
  default = ""
}

/* variable "transfer_config_name_prefix" {
  type    = string
  default = "bq-transfer-"
}
 */
variable "data_source_id" {
  type    = string
  default = ""
}

variable "schedule" {
  type    = string
  default = ""
}

variable "params" {
  type    = map(string)
  default = {}
}