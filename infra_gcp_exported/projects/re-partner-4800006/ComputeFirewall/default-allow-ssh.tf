resource "google_compute_firewall" "default_allow_ssh" {
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  description   = "Allow SSH from anywhere"
  direction     = "INGRESS"
  name          = "default-allow-ssh"
  network       = "https://www.googleapis.com/compute/v1/projects/re-partner-4800006/global/networks/default"
  priority      = 65534
  project       = "re-partner-4800006"
  source_ranges = ["0.0.0.0/0"]
}
# terraform import google_compute_firewall.default_allow_ssh projects/re-partner-4800006/global/firewalls/default-allow-ssh
