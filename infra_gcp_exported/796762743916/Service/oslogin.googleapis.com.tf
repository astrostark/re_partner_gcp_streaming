resource "google_project_service" "oslogin_googleapis_com" {
  project = "796762743916"
  service = "oslogin.googleapis.com"
}
# terraform import google_project_service.oslogin_googleapis_com 796762743916/oslogin.googleapis.com
