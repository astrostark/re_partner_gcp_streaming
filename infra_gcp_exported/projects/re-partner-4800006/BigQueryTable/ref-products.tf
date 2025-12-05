resource "google_bigquery_table" "ref_products" {
  dataset_id = "ecommerce_events"

  labels = {
    managed-by-cnrm = "true"
  }

  project = "re-partner-4800006"
  schema  = "[{\"name\":\"product_id\",\"type\":\"STRING\"}]"

  table_constraints {
    primary_key {
      columns = ["product_id"]
    }
  }

  table_id = "ref_products"
}
# terraform import google_bigquery_table.ref_products projects/re-partner-4800006/datasets/ecommerce_events/tables/ref_products
