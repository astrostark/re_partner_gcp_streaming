resource "google_service_account" "796762743916_compute" {
  account_id   = "796762743916-compute"
  display_name = "Default compute service account"
  project      = "re-partner-4800006"
}
# terraform import google_service_account.796762743916_compute projects/re-partner-4800006/serviceAccounts/796762743916-compute@re-partner-4800006.iam.gserviceaccount.com
