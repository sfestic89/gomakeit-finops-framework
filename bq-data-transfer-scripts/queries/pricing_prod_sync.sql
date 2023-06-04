query = <<-EOF
    CREATE OR REPLACE TABLE `${module.project.project.project_id}.${local.pricing_export_table}` AS
      (
      SELECT
          *
      FROM
        `${local.usage_pricing_export_project_id}.${local.pricing_export_table}`
      )
    EOF