resource "google_bigquery_table" "orders" {
  clustering = ["order_id", "customer_id", "status"]
  dataset_id = "ecommerce_events"

  labels = {
    managed-by-cnrm = "true"
  }

  project = "re-partner-4800006"
  schema  = "[{\"name\":\"event_type\",\"type\":\"STRING\"},{\"name\":\"order_id\",\"type\":\"STRING\"},{\"name\":\"customer_id\",\"type\":\"STRING\"},{\"name\":\"order_date\",\"type\":\"TIMESTAMP\"},{\"name\":\"status\",\"type\":\"STRING\"},{\"fields\":[{\"name\":\"product_id\",\"type\":\"STRING\"},{\"name\":\"product_name\",\"type\":\"STRING\"},{\"name\":\"quantity\",\"type\":\"INTEGER\"},{\"name\":\"price\",\"type\":\"FLOAT\"}],\"mode\":\"REPEATED\",\"name\":\"items\",\"type\":\"RECORD\"},{\"fields\":[{\"name\":\"street\",\"type\":\"STRING\"},{\"name\":\"city\",\"type\":\"STRING\"},{\"name\":\"country\",\"type\":\"STRING\"}],\"name\":\"shipping_address\",\"type\":\"RECORD\"},{\"name\":\"total_amount\",\"type\":\"FLOAT\"},{\"defaultValueExpression\":\"CURRENT_TIMESTAMP()\",\"name\":\"ingestion_time\",\"type\":\"TIMESTAMP\"}]"

  table_constraints {
    foreign_keys {
      column_references {
        referenced_column  = "customer_id"
        referencing_column = "customer_id"
      }

      name = "fk$1"

      referenced_table {
        dataset_id = "ecommerce_events"
        project_id = "re-partner-4800006"
        table_id   = "ref_customers"
      }
    }
  }

  table_id = "orders"

  time_partitioning {
    field = "order_date"
    type  = "DAY"
  }
}
# terraform import google_bigquery_table.orders projects/re-partner-4800006/datasets/ecommerce_events/tables/orders
