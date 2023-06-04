module "finops_gcs_buckets" {
  source = "./modules/finops-gcs-buckets"

  buckets = {
    bucket1 = {
      project       = "terraform-project-385615"
      bucket_name   = "gomakeit-finops-test-bucket"
      location      = "europe-west3"
      storage_class = "STANDARD"
      versioning_enabled = false
      lifecycle_rules = [
        {
          action = {
            type = "Delete"
          }
          condition = {
            age                   = 30
            matches_storage_class = ["STANDARD"]
          }
        }
      ]
      retention_policy = {
        retention_period = 365
        is_locked        = false
      }
      encryption = {
         default_kms_key_name = "projects/my-project/locations/global/keyRings"
      }
    }
  }
}


/* module "finops_notification_channels" {
  source = "./modules/finops-notification-channels"

  notification_channels = {
    email_channel = {
      channel_type  = "email"
      display_name  = "Email"
      description   = "Email Notification for gomakeit Project"
      project       = "test-gomakeit-project"
      channel_value = "sfestic@gomakeit.net"
    },
    pubsub_channel = {
      channel_type  = "pubsub"
      display_name  = "Pub/Sub"
      description   = "Pub/Sub Channel"
      project       = "test-gomakeit-project"
      channel_value = "projects/test-gomakeit-project/topics/notification-channel"
    },
    sms_channel = {
      channel_type  = "sms"
      display_name  = "SMS"
      description   = "SMS"
      project       = "test-gomakeit-project"
      channel_value = "+491789291080"
    }
  }
}

module "finops_budget_alerts" {
  source = "./modules/finops-budget-alerts"

  budgets = {
    budget1 = {
      billing_account = "billingAccounts/014496-8BF4E9-3325DE"
      projects        = ["gomakeit", "vmware-gcp-381708"]
      display_name    = "Test Budget"
      amount          = "1.00"
      currency        = "EUR"
      email           = "sem.festic@gmail.com"

    }
  }

  budget_filters = {
    budget_filter_1 = {
      projects               = ["gomakeit", "vmware-gcp-381708"]
      credit_types_treatment = "INCLUDE_SPECIFIED_CREDITS"
      services               = ["services/24E6-581D-38E5"] # Bigquery
      credit_types           = ["PROMOTION", "FREE_TIER"]
    },
  }

  specified_amount_units = "100000"

  threshold_rules = [
    {
      threshold_percent = 50
      spend_basis       = "CURRENT_SPEND"
    },
    {
      threshold_percent = 75
      spend_basis       = "FORECASTED_SPEND"
    },
  ]

  monitoring_notification_channels = [
    module.finops_notification_channels.notification_ids["email_channel"],
  ]

  last_period_amount = true
}

module "bigquery_datasets" {
  source = "./modules/finops-bigquery/datasets"

  project_id = "gomakeit"
  datasets = {
    "customer_x_cost_export_ds" = {
      friendly_name = "customer_x_cost_export_ds"
      dataset_id    = "customer_x_cost_export_ds"
      labels = {
        "env" = "prod"
      }
      location              = "EU"
      max_time_travel_hours = "168"
    }
    "customer_x_usage_export_ds" = {
      friendly_name = "customer_x_usage_export_ds"
      dataset_id    = "customer_x_usage_export_ds"
      labels = {
        "env" = "prod"
      }
      location              = "EU"
      max_time_travel_hours = "168"
    }
    "customer_x_finops_datasets" = {
      friendly_name = "customer_x_finops_datasets"
      dataset_id    = "customer_x_finops_datasets"
      labels = {
        "env" = "prod"
      }
      location              = "EU"
      max_time_travel_hours = "168"
    }
  }
}
module "bigquery_tables" {
  source     = "./modules/finops-bigquery/tables"
  project_id = "gomakeit"

  tables = {
    "tech_summary_view" = {
      dataset  = module.bigquery_datasets.dataset_ids["customer_x_cost_export_ds"]
      location = "EU"
      labels = {
        dataset = "dashboard"
      }
      deletion_protection = false
      query               = <<-EOF
      SELECT
        ts.execution_time,
        ts.project_id,
        pd.project_name,
        ts.guest_vcpus,
        ts.reserved_cores,
        ts.gcs_storage_gb,
        ts.pubsub_storage_kb,
        ts.bq_storage_gb,
        pd.product,
        pd.domain
      FROM
        `vmware-migration-vmware-lab.finops_data.technical_summary` AS ts
      LEFT JOIN
        `vmware-migration-vmware-lab.finops_data.gcp_project_data_view` pd
      ON
        ts.project_id = pd.project_id
    EOF
    },
  }
}

module "finops_scheduled_queries" {
  source = "./modules/finops-data-transfer"

  project_ids          = []
  display_name         = "aggregate_billing"
  location             = "eu"
  data_source_id       = "scheduled_query"
  schedule             = "every 2 hours from 06:00 to 18:00"
  service_account_name = ""
  depends_on           = [module.bigquery_datasets] #tobetested
  params = {
    query = file("./bq-data-transfer-scripts/queries/budget_data_table.sql") #tobetested
  }

} */