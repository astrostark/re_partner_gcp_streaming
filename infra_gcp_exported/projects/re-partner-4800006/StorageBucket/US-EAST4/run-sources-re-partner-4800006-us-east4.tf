resource "google_storage_bucket" "run_sources_re_partner_4800006_us_east4" {
  cors {
    method = ["GET"]
    origin = ["https://*.cloud.google.com", "https://*.corp.google.com", "https://*.corp.google.com:*", "https://*.cloud.google", "https://*.byoid.goog"]
  }

  force_destroy = false

  labels = {
    managed-by-cnrm = "true"
  }

  location                 = "US-EAST4"
  name                     = "run-sources-re-partner-4800006-us-east4"
  project                  = "re-partner-4800006"
  public_access_prevention = "inherited"

  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
# terraform import google_storage_bucket.run_sources_re_partner_4800006_us_east4 run-sources-re-partner-4800006-us-east4
