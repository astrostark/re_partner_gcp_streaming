resource "google_pubsub_subscription" "backend_events_history_sub" {
  ack_deadline_seconds = 60

  cloud_storage_config {
    bucket          = "re-partner-backup"
    filename_prefix = "events_"
    filename_suffix = ".json"
    max_duration    = "60s"
  }

  expiration_policy {
    ttl = "2678400s"
  }

  labels = {
    managed-by-cnrm = "true"
  }

  message_retention_duration = "604800s"
  name                       = "backend-events-history-sub"
  project                    = "re-partner-4800006"
  topic                      = "projects/re-partner-4800006/topics/backend-events-topic"
}
# terraform import google_pubsub_subscription.backend_events_history_sub projects/re-partner-4800006/subscriptions/backend-events-history-sub
