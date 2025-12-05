resource "google_project_service" "cloudapis_googleapis_com" {
  project = "796762743916"
  service = "cloudapis.googleapis.com"
}
# terraform import google_project_service.cloudapis_googleapis_com 796762743916/cloudapis.googleapis.com
