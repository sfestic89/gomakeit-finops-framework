query = <<-EOF
    BEGIN
    CREATE OR REPLACE TABLE `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["billing_source"].dataset_id}.${google_bigquery_table.table_sku.table_id}`
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
      sku.id AS sku_id,
      sku.description AS sku_description,
      location.location AS location,
      usage.pricing_unit AS usage_pricing_unit,
      SUM(cost) AS cost,
      SUM(IFNULL((
          SELECT
            SUM(c.amount)
          FROM
            UNNEST(credits) c), 0)) AS credits_amount,
      SUM(usage.amount_in_pricing_units) AS usage_amount_in_pricing_units,
      CASE
        WHEN project.ancestry_numbers IS NULL THEN TRUE
      ELSE
        FALSE
      END
        AS has_hierarchy,
      IF
        (service.description IN (
          SELECT service FROM `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["billing_source"].dataset_id}.${google_bigquery_table.view_marketplace.table_id}`), TRUE, FALSE) AS is_marketplace,
      domain_name,
      product_name,
      environment,
      product_id
      FROM
        `${local.billing_project_id}.${local.billing_export_table}` b
      LEFT JOIN
        `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["billing_source"].dataset_id}.${google_bigquery_table.view_project_meta_data.table_id}` pl
      ON
        b.project.id = pl.project_id
      WHERE
        DATE(_PARTITIONTIME) >= DATE(2020,10,01)
      GROUP BY
        invoice_month,
        invoice_day,
        project_id,
        project_name,
        service,
        sku_id,
        sku_description,
        usage_pricing_unit,
        location,
        has_hierarchy,
        domain_name,
        product_name,
        environment,
        product_id
      );

    CREATE OR REPLACE TABLE `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["billing_source"].dataset_id}.${google_bigquery_table.table_service.table_id}`
    PARTITION BY
      invoice_day
    CLUSTER BY
      domain_name,
      product_name,
      project_id,
      service
    AS (
      SELECT
        invoice_month,
        invoice_day,
        project_id,
        project_name,
        service,
        location,
        is_marketplace,
        domain_name,
        product_name,
        environment,
        product_id,
        CASE
          WHEN EXTRACT(MONTH FROM invoice_day) IN (10, 11, 12) THEN EXTRACT(YEAR FROM invoice_day) + 1
          WHEN EXTRACT(MONTH FROM invoice_day) IN (1, 2, 3, 4, 5, 6, 7, 8, 9) THEN EXTRACT(YEAR FROM invoice_day)
        END as financial_year,
        SUM(cost) as cost,
        SUM(credits_amount) as credits_amount
      FROM
        `${module.project.project.project_id}.${google_bigquery_dataset.finops_datasets["billing_source"].dataset_id}.${google_bigquery_table.table_sku.table_id}`
      GROUP BY
        invoice_month,
        invoice_day,
        project_id,
        project_name,
        service,
        location,
        is_marketplace,
        domain_name,
        product_name,
        environment,
        product_id
      );
    END;
    EOF