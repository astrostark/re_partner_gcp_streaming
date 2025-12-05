resource "google_project_service" "dataform_googleapis_com" {
  project = "796762743916"
  service = "dataform.googleapis.com"
}
# terraform import google_project_service.dataform_googleapis_com 796762743916/dataform.googleapis.com
