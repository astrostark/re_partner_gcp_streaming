resource "google_project_service" "cloudbuild_googleapis_com" {
  project = "796762743916"
  service = "cloudbuild.googleapis.com"
}
# terraform import google_project_service.cloudbuild_googleapis_com 796762743916/cloudbuild.googleapis.com
