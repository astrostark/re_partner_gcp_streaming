resource "google_project_service" "bigquery_googleapis_com" {
  project = "796762743916"
  service = "bigquery.googleapis.com"
}
# terraform import google_project_service.bigquery_googleapis_com 796762743916/bigquery.googleapis.com
