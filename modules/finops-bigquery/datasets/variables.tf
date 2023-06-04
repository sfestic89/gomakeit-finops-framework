variable "project_id" {
  description = "The ID of the GCP project where the datasets and tables will be created."
}

variable "datasets" {
  description = "A map of BigQuery datasets to create, where the key is the dataset name and the value is a map of dataset properties."
  type        = map(any)
}
