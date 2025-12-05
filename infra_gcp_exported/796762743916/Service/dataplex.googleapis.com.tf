resource "google_project_service" "dataplex_googleapis_com" {
  project = "796762743916"
  service = "dataplex.googleapis.com"
}
# terraform import google_project_service.dataplex_googleapis_com 796762743916/dataplex.googleapis.com
