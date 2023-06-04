/* output "bucket_names" {
  description = "A map of created GCS buckets and their names."
  value       = { for key, value in google_storage_bucket.buckets : key => value.name }
} */