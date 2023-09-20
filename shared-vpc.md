### Architecture

![shared vpc](/images/nih-shared-vpc.png)

### Create Host Project and Service Projects

#### Create Projects
- Create a project to act as the host project for the Shared VPC.
- Create a project to act as the onPrem service project
- Create a project to act as the Cloud service project.

#### Create VPC and Subnets

- Create VPC in Host Project
- Create onPrem Subnet
- Create Cloud Subnet


```provider "google" {
  credentials = file(var.service_account_json)
}

variable "service_account_json" {
  description = "Path to the service account JSON file"
}

variable "org_id" {
  description = "The organization ID for the projects"
}

// Create host project
resource "google_project" "host_project" {
  name       = "host-project"
  project_id = "host-project-id"
  org_id     = var.org_id
}

// Create first service project
resource "google_project" "service_project1" {
  name       = "service-project1"
  project_id = "service-project1-id"
  org_id     = var.org_id
}

// Create second service project
resource "google_project" "service_project2" {
  name       = "service-project2"
  project_id = "service-project2-id"
  org_id     = var.org_id
}

// Create VPC in host project
resource "google_compute_network" "shared_vpc" {
  name                    = "shared-vpc"
  project                 = google_project.host_project.project_id
  auto_create_subnetworks = false
}

// Create first subnet in the VPC
resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.shared_vpc.self_link
}

// Create second subnet in the VPC
resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = "10.0.2.0/24"
  region        = "us-central1"
  network       = google_compute_network.shared_vpc.self_link
}

// Enable Shared VPC feature for host project
resource "google_compute_shared_vpc_host_project" "host_project" {
  project = google_project.host_project.project_id
}

// Attach the first service project to the Shared VPC
resource "google_compute_shared_vpc_service_project" "service_project1" {
  host_project     = google_compute_shared_vpc_host_project.host_project.project
  service_project  = google_project.service_project1.project_id
}

// Attach the second service project to the Shared VPC
resource "google_compute_shared_vpc_service_project" "service_project2" {
  host_project     = google_compute_shared_vpc_host_project.host_project.project
  service_project  = google_project.service_project2.project_id
}


```

### IAM ROLES

```
// Previous code remains the same

// Add IAM role to a service account in the first service project
resource "google_project_iam_member" "service_project1_iam" {
  project = google_project.service_project1.project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_project.service_project1.project_id}@appspot.gserviceaccount.com"
}

// Add IAM role to a service account in the second service project
resource "google_project_iam_member" "service_project2_iam" {
  project = google_project.service_project2.project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_project.service_project2.project_id}@appspot.gserviceaccount.com"
}
```