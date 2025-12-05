resource "google_project_service" "cloudtrace_googleapis_com" {
  project = "796762743916"
  service = "cloudtrace.googleapis.com"
}
# terraform import google_project_service.cloudtrace_googleapis_com 796762743916/cloudtrace.googleapis.com
