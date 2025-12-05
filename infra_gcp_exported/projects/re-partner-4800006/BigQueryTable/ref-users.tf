resource "google_bigquery_table" "ref_users" {
  dataset_id = "ecommerce_events"

  labels = {
    managed-by-cnrm = "true"
  }

  project = "re-partner-4800006"
  schema  = "[{\"name\":\"user_id\",\"type\":\"STRING\"}]"

  table_constraints {
    primary_key {
      columns = ["user_id"]
    }
  }

  table_id = "ref_users"
}
# terraform import google_bigquery_table.ref_users projects/re-partner-4800006/datasets/ecommerce_events/tables/ref_users
