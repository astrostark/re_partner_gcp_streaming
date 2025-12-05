resource "google_pubsub_topic" "backend_events_topic" {
  labels = {
    managed-by-cnrm = "true"
  }

  name    = "backend-events-topic"
  project = "re-partner-4800006"
}
# terraform import google_pubsub_topic.backend_events_topic projects/re-partner-4800006/topics/backend-events-topic
