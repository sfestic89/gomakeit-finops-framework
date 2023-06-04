resource "google_bigquery_table" "tables" {
  for_each = var.tables

  dataset_id          = each.value.dataset
  table_id            = each.key
  project             = var.project_id
  deletion_protection = false
  dynamic "view" {
    for_each = var.query == null ? [] : [var.query]
    content {
      query          = view.value.query
      use_legacy_sql = view.value.use_legacy_sql
    }
  }
}