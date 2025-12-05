resource "google_project_service" "run_googleapis_com" {
  project = "796762743916"
  service = "run.googleapis.com"
}
# terraform import google_project_service.run_googleapis_com 796762743916/run.googleapis.com
