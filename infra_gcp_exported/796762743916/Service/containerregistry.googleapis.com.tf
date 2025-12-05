resource "google_project_service" "containerregistry_googleapis_com" {
  project = "796762743916"
  service = "containerregistry.googleapis.com"
}
# terraform import google_project_service.containerregistry_googleapis_com 796762743916/containerregistry.googleapis.com
