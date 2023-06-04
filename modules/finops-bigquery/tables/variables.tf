variable "project_id" {
  description = "The ID of the GCP project where the datasets and tables will be created."
}

variable "tables" {
  description = "A map of BigQuery tables to create, where the key is the table name and the value is a map of table properties."
  type        = map(any)
}

variable "query" {
  type    = string
  default = null
}

variable "use_legacy_sql" {
  type    = string
  default = "false"
}
