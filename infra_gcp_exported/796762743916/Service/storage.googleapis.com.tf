resource "google_project_service" "storage_googleapis_com" {
  project = "796762743916"
  service = "storage.googleapis.com"
}
# terraform import google_project_service.storage_googleapis_com 796762743916/storage.googleapis.com
