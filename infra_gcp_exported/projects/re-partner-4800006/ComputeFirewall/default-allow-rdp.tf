resource "google_compute_firewall" "default_allow_rdp" {
  allow {
    ports    = ["3389"]
    protocol = "tcp"
  }

  description   = "Allow RDP from anywhere"
  direction     = "INGRESS"
  name          = "default-allow-rdp"
  network       = "https://www.googleapis.com/compute/v1/projects/re-partner-4800006/global/networks/default"
  priority      = 65534
  project       = "re-partner-4800006"
  source_ranges = ["0.0.0.0/0"]
}
# terraform import google_compute_firewall.default_allow_rdp projects/re-partner-4800006/global/firewalls/default-allow-rdp
