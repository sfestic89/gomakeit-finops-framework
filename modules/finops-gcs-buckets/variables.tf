variable "buckets" {
  description = "A map of bucket configurations."
  type = map(object({
    project       = string
    bucket_name   = string
    location      = string
    storage_class = string

    versioning_enabled = optional(bool)
    lifecycle_rules = optional(list(object({
      action = object({
        type = string
      })
      condition = object({
        age                   = optional(number)
        created_before        = optional(string)
        matches_storage_class = optional(list(string))
        num_newer_versions    = optional(number)
      })
    })))
    retention_policy = optional(object({
      retention_period = optional(number)
      is_locked        = optional(bool)
    }))
    website = optional(object({
      main_page_suffix = optional(string)
      not_found_page   = optional(string)
    }))
    cors = optional(list(object({
      origin          = optional(string)
      method          = optional(list(string))
      response_header = optional(list(string))
      max_age_seconds = optional(number)
    })))
    encryption = optional(object({
      default_kms_key_name = optional(string)
    }))
    # Add any other bucket-specific configuration attributes as needed
  }))
}