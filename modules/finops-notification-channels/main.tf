resource "google_monitoring_notification_channel" "gcp" {
  for_each = var.notification_channels

  type         = each.value.channel_type
  display_name = each.value.display_name
  description  = each.value.description
  project      = each.value.project

  # Add channel-specific labels based on the type
  labels = merge(
    each.value.channel_type == "email" ? {
      "email_address" = each.value.channel_value
      } : each.value.channel_type == "slack" ? {
      "channel_name" = each.value.channel_value
      } : each.value.channel_type == "sms" ? {
      "number" = each.value.channel_value
      } : each.value.channel_type == "pubsub" ? {
      "topic" = each.value.channel_value
    } : {}
  )
}
