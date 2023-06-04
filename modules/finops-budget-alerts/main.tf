resource "google_billing_budget" "budget" {
  for_each = var.budgets

  billing_account = each.value.billing_account
  display_name    = each.value.display_name

  dynamic "budget_filter" {
    for_each = var.budget_filters
    content {
      projects               = ["budget_filter.value.projects"]
      credit_types_treatment = budget_filter.value.credit_types_treatment
      services               = ["budget_filter.value.services"]
      credit_types           = budget_filter.value.credit_types
    }
  }
  dynamic "amount" {
    for_each = var.specified_amount_units == "0" ? [] : [1]
    content {
      specified_amount {
        currency_code = "EUR"
        units         = var.specified_amount_units
      }
    }
  }

  /*   dynamic "amount" {
    for_each = var.last_period_amount ? [1] : []
    content {
      last_period_amount = true
    }
  }
 */

  /*  dynamic "threshold_rules" {
    for_each = var.threshold_rules
    content {
      threshold_percent = threshold_rules.value.threshold_percent
      spend_basis       = threshold_rules.value.spend_basis
    }
  } */

  all_updates_rule {
    monitoring_notification_channels = var.monitoring_notification_channels
    disable_default_iam_recipients   = true
  }

  dynamic "threshold_rules" {
    for_each = var.threshold_rules
    content {
      threshold_percent = threshold_rules.value.threshold_percent
      spend_basis       = threshold_rules.value.spend_basis
    }
  }
}
