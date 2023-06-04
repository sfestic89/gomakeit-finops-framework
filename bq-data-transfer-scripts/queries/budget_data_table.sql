query = <<-EOF
    CREATE OR REPLACE TABLE `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["dashboard_data"].dataset_id}.budget_data_table` AS
      (
      SELECT
          *
      FROM
        `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["dashboard_data"].dataset_id}.budget_table`
      )
    EOF


    /* module.project.project.project_id - finops gcp project */