resource "google_project_service" "iam_googleapis_com" {
  project = "796762743916"
  service = "iam.googleapis.com"
}
# terraform import google_project_service.iam_googleapis_com 796762743916/iam.googleapis.com
