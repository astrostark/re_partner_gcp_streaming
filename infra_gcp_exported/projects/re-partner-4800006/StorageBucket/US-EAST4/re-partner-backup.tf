resource "google_storage_bucket" "re_partner_backup" {
  force_destroy = false

  labels = {
    managed-by-cnrm = "true"
  }

  location                 = "US-EAST4"
  name                     = "re-partner-backup"
  project                  = "re-partner-4800006"
  public_access_prevention = "enforced"

  soft_delete_policy {
    retention_duration_seconds = 604800
  }

  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
}
# terraform import google_storage_bucket.re_partner_backup re-partner-backup
