resource "google_bigquery_table" "ref_customers" {
  dataset_id = "ecommerce_events"

  labels = {
    managed-by-cnrm = "true"
  }

  project = "re-partner-4800006"
  schema  = "[{\"name\":\"customer_id\",\"type\":\"STRING\"}]"

  table_constraints {
    primary_key {
      columns = ["customer_id"]
    }
  }

  table_id = "ref_customers"
}
# terraform import google_bigquery_table.ref_customers projects/re-partner-4800006/datasets/ecommerce_events/tables/ref_customers
