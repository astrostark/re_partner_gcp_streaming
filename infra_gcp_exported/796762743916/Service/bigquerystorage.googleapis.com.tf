resource "google_project_service" "bigquerystorage_googleapis_com" {
  project = "796762743916"
  service = "bigquerystorage.googleapis.com"
}
# terraform import google_project_service.bigquerystorage_googleapis_com 796762743916/bigquerystorage.googleapis.com
