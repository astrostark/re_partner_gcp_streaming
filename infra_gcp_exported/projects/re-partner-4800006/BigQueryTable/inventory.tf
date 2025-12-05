resource "google_bigquery_table" "inventory" {
  clustering = ["inventory_id", "product_id", "warehouse_id", "reason"]
  dataset_id = "ecommerce_events"

  labels = {
    managed-by-cnrm = "true"
  }

  project = "re-partner-4800006"
  schema  = "[{\"name\":\"event_type\",\"type\":\"STRING\"},{\"name\":\"inventory_id\",\"type\":\"STRING\"},{\"name\":\"product_id\",\"type\":\"STRING\"},{\"name\":\"warehouse_id\",\"type\":\"STRING\"},{\"name\":\"quantity_change\",\"type\":\"INTEGER\"},{\"name\":\"reason\",\"type\":\"STRING\"},{\"name\":\"timestamp\",\"type\":\"TIMESTAMP\"},{\"defaultValueExpression\":\"CURRENT_TIMESTAMP()\",\"name\":\"ingestion_time\",\"type\":\"TIMESTAMP\"}]"

  table_constraints {
    foreign_keys {
      column_references {
        referenced_column  = "product_id"
        referencing_column = "product_id"
      }

      name = "fk$1"

      referenced_table {
        dataset_id = "ecommerce_events"
        project_id = "re-partner-4800006"
        table_id   = "ref_products"
      }
    }

    foreign_keys {
      column_references {
        referenced_column  = "warehouse_id"
        referencing_column = "warehouse_id"
      }

      name = "fk$2"

      referenced_table {
        dataset_id = "ecommerce_events"
        project_id = "re-partner-4800006"
        table_id   = "ref_warehouses"
      }
    }
  }

  table_id = "inventory"

  time_partitioning {
    field = "timestamp"
    type  = "DAY"
  }
}
# terraform import google_bigquery_table.inventory projects/re-partner-4800006/datasets/ecommerce_events/tables/inventory
