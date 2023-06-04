output "notification_ids" {
  value = { for k, v in google_monitoring_notification_channel.gcp : k => v.id }
}