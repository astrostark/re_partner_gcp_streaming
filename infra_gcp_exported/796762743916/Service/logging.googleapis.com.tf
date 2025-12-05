resource "google_project_service" "logging_googleapis_com" {
  project = "796762743916"
  service = "logging.googleapis.com"
}
# terraform import google_project_service.logging_googleapis_com 796762743916/logging.googleapis.com
