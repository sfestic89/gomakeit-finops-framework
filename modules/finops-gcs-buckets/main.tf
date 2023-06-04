/* resource "google_project_iam_member" "project_iam_member" {
  for_each = var.buckets

  project = each.value.project
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_storage_bucket.buckets[each.key].project_team[0].team_member}"
}
 */
resource "google_storage_bucket" "buckets" {
  for_each = var.buckets

  name     = each.value.bucket_name
  location = each.value.location
  project  = each.value.project

  # Additional bucket-specific configuration options can be added here

  storage_class               = each.value.storage_class
  uniform_bucket_level_access = true

  dynamic "versioning" {
    for_each = can(var.buckets[each.key].versioning_enabled) ? [true] : []
    content {
      enabled = var.buckets[each.key].versioning_enabled
    }
  }

  dynamic "lifecycle_rule" {
    for_each = can(var.buckets[each.key].lifecycle_rules) ? [true] : []
    content {
      dynamic "action" {
        for_each = [var.buckets[each.key].lifecycle_rules[0].action]
        content {
          type = action.value.type
        }
      }

      dynamic "condition" {
        for_each = [var.buckets[each.key].lifecycle_rules[0].condition]
        content {
          age                   = condition.value.age
          created_before        = condition.value.created_before
          matches_storage_class = condition.value.matches_storage_class
          num_newer_versions    = condition.value.num_newer_versions
        }
      }
    }
  }

  dynamic "retention_policy" {
    for_each = can(var.buckets[each.key].retention_policy) ? [true] : []
    content {
      retention_period = var.buckets[each.key].retention_policy.retention_period
      is_locked        = var.buckets[each.key].retention_policy.is_locked
    }
  }

  /* dynamic "website" {
    for_each = can(var.buckets[each.key].website) ? [true] : []
    content {
      main_page_suffix = var.buckets[each.key].website.main_page_suffix
      not_found_page   = var.buckets[each.key].website.not_found_page
    }
  }
 */
  /* dynamic "cors" {
    for_each = can(var.buckets[each.key].cors) ? [true] : []
    content {
      origin          = var.buckets[each.key].cors.origin
      method          = var.buckets[each.key].cors.method
      response_header = var.buckets[each.key].cors.response_header
      max_age_seconds = var.buckets[each.key].cors.max_age_seconds


    }
  } */
  /* dynamic "encryption" {
    for_each = can(var.buckets[each.key].encryption) ? [true] : []
    content {
      default_kms_key_name = var.buckets[each.key].encryption.default_kms_key_name
    }
  } */
  dynamic "encryption" {
    for_each = can(each.value.encryption) ? [true] : []
    content {
      default_kms_key_name = can(each.value.encryption.default_kms_key_name) ? each.value.encryption.default_kms_key_name : null
    }
  }

  # Add any other necessary resource dependencies

  # ...
}