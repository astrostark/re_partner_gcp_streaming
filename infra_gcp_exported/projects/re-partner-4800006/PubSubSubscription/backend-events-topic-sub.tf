resource "google_pubsub_subscription" "backend_events_topic_sub" {
  ack_deadline_seconds = 10

  expiration_policy {
    ttl = "2678400s"
  }

  labels = {
    managed-by-cnrm = "true"
  }

  message_retention_duration = "604800s"
  name                       = "backend-events-topic-sub"
  project                    = "re-partner-4800006"
  topic                      = "projects/re-partner-4800006/topics/backend-events-topic"
}
# terraform import google_pubsub_subscription.backend_events_topic_sub projects/re-partner-4800006/subscriptions/backend-events-topic-sub
