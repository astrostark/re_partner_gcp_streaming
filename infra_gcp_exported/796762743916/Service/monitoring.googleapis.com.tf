resource "google_project_service" "monitoring_googleapis_com" {
  project = "796762743916"
  service = "monitoring.googleapis.com"
}
# terraform import google_project_service.monitoring_googleapis_com 796762743916/monitoring.googleapis.com
