variable "notification_channels" {
  description = "The configuration for different notification channels."
  type = map(object({
    channel_type  = string
    display_name  = string
    description   = string
    project       = string
    channel_value = string
  }))
}