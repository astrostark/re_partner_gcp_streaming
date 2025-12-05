resource "google_bigquery_dataset" "ecommerce_events" {
  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }

  access {
    role          = "OWNER"
    user_by_email = "luanbbastos@gmail.com"
  }

  access {
    role          = "READER"
    special_group = "projectReaders"
  }

  access {
    role          = "WRITER"
    special_group = "projectWriters"
  }

  dataset_id                 = "ecommerce_events"
  delete_contents_on_destroy = false

  labels = {
    managed-by-cnrm = "true"
  }

  location              = "us-east4"
  max_time_travel_hours = "168"
  project               = "re-partner-4800006"
}
# terraform import google_bigquery_dataset.ecommerce_events projects/re-partner-4800006/datasets/ecommerce_events
