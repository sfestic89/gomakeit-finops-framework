variable "budgets" {
  type = map(object({
    billing_account = string
    projects        = list(string)
    display_name    = string
    amount          = number
    currency        = string
    email           = string
  }))
}

/* variable "projects" {
  type = list(string)
}
 */
variable "budget_filters" {
  type = map(object({
    projects               = list(string)
    credit_types_treatment = string
    services               = list(string)
    credit_types           = list(string)
  }))
  /* default = {
    "filter1" = {
      projects               = ["projects/${data.google_project.project.number}"]
      credit_types_treatment = "INCLUDE_SPECIFIED_CREDITS"
      services               = ["services/24E6-581D-38E5"] # Bigquery
      credit_types           = ["PROMOTION", "FREE_TIER"]
    },
    "filter2" = {
      projects               = ["projects/${data.google_project.project.number}"]
      credit_types_treatment = "INCLUDE_ALL_CREDITS"
      services               = ["services/24E6-581D-38E5"] # Bigquery
      credit_types           = []
    }
  } */
}
variable "threshold_rules" {
  description = "Rules that trigger alerts when spend exceeds the specified percentages of the budget"
  type = list(object({
    threshold_percent = number
    spend_basis       = string
  }))
  default = [{
    threshold_percent = 0.5
    spend_basis       = "CURRENT_SPEND"
    },
    {
      threshold_percent = 0.75
      spend_basis       = "CURRENT_SPEND"
    },
    {
      threshold_percent = 1.0
      spend_basis       = "CURRENT_SPEND"
  }]
}

variable "specified_amount_units" {
  description = "Configures a budget amount to fixed threshold in Euro(€)"
  type        = string
  default     = "0"
}

variable "last_period_amount" {
  description = "Configures a budget amount that is automatically set to 100% of last period's spend"
  type        = bool
  default     = false
}

variable "monitoring_notification_channels" {
  description = "List of email addresses to receive alert notification"
  type        = list(string)
}
