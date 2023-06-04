query = <<-EOF
    CREATE OR REPLACE TABLE `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["billing_source"].dataset_id}.${google_bigquery_table.table_credit.table_id}`
    PARTITION BY
      invoice_day
    CLUSTER BY
      domain_name,
      product_name,
      project_id,
      service
    AS (
      SELECT
        invoice.month AS invoice_month,
        DATE_TRUNC(DATE(usage_start_time,"America/Los_Angeles"), DAY) AS invoice_day,
        project.id AS project_id,
        pl.project_name AS project_name,
        service.description AS service,
        IF
          (service.description IN (
            SELECT service FROM `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["billing_source"].dataset_id}.${google_bigquery_table.view_marketplace.table_id}`), TRUE, FALSE) AS is_marketplace,
        domain_name,
        product_name,
        environment,
        product_id,
        c.id AS credits_id,
        c.type AS credits_type,
        c.name AS credits_name,
        c.full_name AS credits_fullname,
        SUM(IFNULL(c.amount, 0)) AS credits_amount
      FROM
        `${local.billing_project_id}.${local.billing_export_table}` b,
        UNNEST(credits) AS c
      LEFT JOIN
        `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["billing_source"].dataset_id}.${google_bigquery_table.view_project_meta_data.table_id}` pl
      ON
        b.project.id = pl.project_id
      WHERE
        DATE(_PARTITIONTIME) >= DATE(2020,10,01)
      GROUP BY
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
      )
    EOF