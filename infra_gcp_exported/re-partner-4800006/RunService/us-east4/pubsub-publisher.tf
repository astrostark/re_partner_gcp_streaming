resource "google_cloud_run_v2_service" "pubsub_publisher" {
  client  = "cloud-console"
  ingress = "INGRESS_TRAFFIC_ALL"

  labels = {
    managed-by-cnrm = "true"
  }

  launch_stage = "GA"
  location     = "us-east4"
  name         = "pubsub-publisher"
  project      = "re-partner-4800006"

  template {
    containers {
      image = "us-east4-docker.pkg.dev/re-partner-4800006/cloud-run-source-deploy/pubsub-publisher@sha256:7d5eca5ee23d09c83d10476ab6df3e5aed1746e2cd11fee9ad70543a5b4d0b60"
      name  = "pubsub-publisher-1"

      ports {
        container_port = 8080
        name           = "http1"
      }

      resources {
        cpu_idle = true

        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }

        startup_cpu_boost = true
      }

      startup_probe {
        failure_threshold     = 1
        initial_delay_seconds = 0
        period_seconds        = 240

        tcp_socket {
          port = 8080
        }

        timeout_seconds = 240
      }
    }

    max_instance_request_concurrency = 80

    scaling {
      max_instance_count = 20
    }

    service_account = "796762743916-compute@developer.gserviceaccount.com"
    timeout         = "300s"
  }

  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}
# terraform import google_cloud_run_v2_service.pubsub_publisher projects/re-partner-4800006/locations/us-east4/services/pubsub-publisher
