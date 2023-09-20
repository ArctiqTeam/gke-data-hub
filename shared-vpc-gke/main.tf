# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###############################################################################
#                          Host and service projects                          #
###############################################################################

# the container.hostServiceAgentUser role is needed for GKE on shared VPC
# see: https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-shared-vpc#grant_host_service_agent_role

module "project-host" {
  source          = "../modules/project"
  parent          = var.root_node
  billing_account = var.billing_account_id
  prefix          = var.prefix
  name            = "net"
  services        = concat(var.project_services, ["dns.googleapis.com"])
  shared_vpc_host_config = {
    enabled = true
  }
  # iam = {
  #   "roles/owner" = ["group:network-admins@${var.domain}"]
  # }
}

module "project-svc-gke" {
  source          = "../modules/project"
  parent          = var.root_node
  billing_account = var.billing_account_id
  prefix          = var.prefix
  name            = "gke"
  services        = var.project_services
  shared_vpc_service_config = {
    host_project = module.project-host.project_id
    service_identity_iam = {
      "roles/container.hostServiceAgentUser" = ["container-engine"]
      "roles/compute.networkUser"            = ["container-engine"]
    }
  }
  # group_iam = {
  #   "cluster-admins@${var.domain}" = ["roles/owner","roles/container.clusterAdmin"]
  # }
}

module "project-svc-gke-onprem" {
  source          = "../modules/project"
  parent          = var.root_node
  billing_account = var.billing_account_id
  prefix          = var.prefix
  name            = "gke-onprem"
  services        = var.project_services
  shared_vpc_service_config = {
    host_project = module.project-host.project_id
    service_identity_iam = {
      "roles/container.hostServiceAgentUser" = ["container-engine"]
      "roles/compute.networkUser"            = ["container-engine"]
    }
  }
}