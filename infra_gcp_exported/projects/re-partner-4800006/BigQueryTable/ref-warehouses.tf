resource "google_bigquery_table" "ref_warehouses" {
  dataset_id = "ecommerce_events"

  labels = {
    managed-by-cnrm = "true"
  }

  project = "re-partner-4800006"
  schema  = "[{\"name\":\"warehouse_id\",\"type\":\"STRING\"}]"

  table_constraints {
    primary_key {
      columns = ["warehouse_id"]
    }
  }

  table_id = "ref_warehouses"
}
# terraform import google_bigquery_table.ref_warehouses projects/re-partner-4800006/datasets/ecommerce_events/tables/ref_warehouses
