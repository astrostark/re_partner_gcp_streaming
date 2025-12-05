resource "google_project_service" "recommender_googleapis_com" {
  project = "796762743916"
  service = "recommender.googleapis.com"
}
# terraform import google_project_service.recommender_googleapis_com 796762743916/recommender.googleapis.com
