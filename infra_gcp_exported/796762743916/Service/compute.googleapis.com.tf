resource "google_project_service" "compute_googleapis_com" {
  project = "796762743916"
  service = "compute.googleapis.com"
}
# terraform import google_project_service.compute_googleapis_com 796762743916/compute.googleapis.com
