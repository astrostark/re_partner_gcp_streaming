resource "google_project_service" "datastore_googleapis_com" {
  project = "796762743916"
  service = "datastore.googleapis.com"
}
# terraform import google_project_service.datastore_googleapis_com 796762743916/datastore.googleapis.com
