resource "google_bigquery_data_transfer_config" "query_config" {
  for_each = { for project_id in var.project_ids : project_id => project_id }

  project        = each.value.project_ids
  data_source_id = var.data_source_id
  display_name   = var.display_name
  service_account_name = var.service_account_name
  location = var.location

  schedule = var.schedule

  params = var.params

  destination_dataset_id = var.dataset_id
}