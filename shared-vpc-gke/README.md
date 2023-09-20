### Architecture

![shared vpc](../images/nih-shared-vpc.png)

### Create Host Project and Service Projects

#### Create Projects
- Create a project to act as the host project for the Shared VPC.
- Create a project to act as the dev fleet service project
- Create a project to act as the prod fleet service project.

#### Create VPC and Subnets
- Create VPC in Host Project
- Create dev Subnet
- Create prod Subnet

### Roles required for GKE onPrem

Role | Purpose
--- | ---
roles/compute.viewer | Required: Needed when bmctl validates the clusterOperations.location field in the cluster configuration file.
roles/iam.serviceAccountAdmin | Required: Needed to create the service accounts that that Anthos clusters on bare metal requires.
roles/iam.securityAdmin | Required: Needed to grant IAM roles to the service accounts that Anthos clusters on bare metal requires.
roles/iam.serviceAccountKeyAdmin | Required: Needed to create JSON key files for the service accounts that Anthos clusters on bare metal requires.
roles/serviceusage.serviceUsageAdmin | Required: Needed to enable the Google APIs that Anthos clusters on bare metal requires.
roles/gkeonprem.admin | Optional: Needed if you want to create clusters using Anthos On-Prem API clients or configure a cluster to be managed by the Anthos On-Prem API.
roles/gkehub.viewer
roles/container.viewer | Optional: Needed if you want to access the Anthos and Google Kubernetes Engine pages in the Google Cloud console.

### APIs required for GKE onPrem

```
anthos.googleapis.com
anthosaudit.googleapis.com
anthosgke.googleapis.com
cloudresourcemanager.googleapis.com
connectgateway.googleapis.com
container.googleapis.com
gkeconnect.googleapis.com
gkehub.googleapis.com
gkeonprem.googleapis.com
iam.googleapis.com
logging.googleapis.com
monitoring.googleapis.com
opsconfigmonitoring.googleapis.com
serviceusage.googleapis.com
stackdriver.googleapis.com
storage.googleapis.com
```

For further information about GKE onprem requirements, read [here](https://cloud.google.com/anthos/clusters/docs/bare-metal/latest/installing/configure-sa)

### APIs required for fleet-managed GKE

```
container.googleapis.com
gkeconnect.googleapis.com
gkehub.googleapis.com
cloudresourcemanager.googleapis.com
iam.googleapis.com
```

For further information about GKE fleet management requirements, read [here](https://cloud.google.com/anthos/fleet-management/docs/before-you-begin)