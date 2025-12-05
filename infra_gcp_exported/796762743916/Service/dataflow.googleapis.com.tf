resource "google_project_service" "dataflow_googleapis_com" {
  project = "796762743916"
  service = "dataflow.googleapis.com"
}
# terraform import google_project_service.dataflow_googleapis_com 796762743916/dataflow.googleapis.com
