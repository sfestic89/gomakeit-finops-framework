resource "google_bigquery_dataset" "datasets" {
  for_each = var.datasets

  dataset_id = each.key
  project    = var.project_id
  labels     = each.value.labels
  location   = each.value.location
}

