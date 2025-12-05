resource "google_bigquery_table" "user_activity" {
  clustering = ["user_id", "activity_type"]
  dataset_id = "ecommerce_events"

  labels = {
    managed-by-cnrm = "true"
  }

  project = "re-partner-4800006"
  schema  = "[{\"name\":\"event_type\",\"type\":\"STRING\"},{\"name\":\"user_id\",\"type\":\"STRING\"},{\"name\":\"activity_type\",\"type\":\"STRING\"},{\"name\":\"ip_address\",\"type\":\"STRING\"},{\"name\":\"user_agent\",\"type\":\"STRING\"},{\"name\":\"timestamp\",\"type\":\"TIMESTAMP\"},{\"fields\":[{\"name\":\"session_id\",\"type\":\"STRING\"},{\"name\":\"platform\",\"type\":\"STRING\"}],\"name\":\"metadata\",\"type\":\"RECORD\"},{\"defaultValueExpression\":\"CURRENT_TIMESTAMP()\",\"name\":\"ingestion_time\",\"type\":\"TIMESTAMP\"}]"

  table_constraints {
    foreign_keys {
      column_references {
        referenced_column  = "user_id"
        referencing_column = "user_id"
      }

      name = "fk$1"

      referenced_table {
        dataset_id = "ecommerce_events"
        project_id = "re-partner-4800006"
        table_id   = "ref_users"
      }
    }
  }

  table_id = "user_activity"

  time_partitioning {
    field = "timestamp"
    type  = "DAY"
  }
}
# terraform import google_bigquery_table.user_activity projects/re-partner-4800006/datasets/ecommerce_events/tables/user_activity
