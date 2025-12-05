resource "google_project_service" "pubsub_googleapis_com" {
  project = "796762743916"
  service = "pubsub.googleapis.com"
}
# terraform import google_project_service.pubsub_googleapis_com 796762743916/pubsub.googleapis.com
