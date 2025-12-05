resource "google_artifact_registry_repository" "cloud_run_source_deploy" {
  description = "Cloud Run Source Deployments"
  format      = "DOCKER"

  labels = {
    managed-by-cnrm = "true"
  }

  location      = "us-east4"
  mode          = "STANDARD_REPOSITORY"
  project       = "re-partner-4800006"
  repository_id = "cloud-run-source-deploy"
}
# terraform import google_artifact_registry_repository.cloud_run_source_deploy projects/re-partner-4800006/locations/us-east4/repositories/cloud-run-source-deploy
