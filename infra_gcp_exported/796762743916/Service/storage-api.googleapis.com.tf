resource "google_project_service" "storage_api_googleapis_com" {
  project = "796762743916"
  service = "storage-api.googleapis.com"
}
# terraform import google_project_service.storage_api_googleapis_com 796762743916/storage-api.googleapis.com
