# Architecture of Azure Cloud Foundations
![Subscriptions](images/architecture.png)

## Environment Organisation
![Management Groups](images/management-groups.png)

Environment separation is achieved through the use of separate subscriptions for each workload environment; including compliance, hub and workload environment (dev/test/prod) subscriptions:

* Default subscription structure:
  * Core subscriptions: *compliance* and *hub*
  * Workload subscriptions: *dev*, *test*, and *prod*
* Management Group structure
  * Enables management of role assignments and policy assignments outside of the subscription
  * Follows a subscription per environment methodology

## Networking
![Network Peering](images/network-peering.png)

Private networks, including Virtual Network and subnet design, site-to-site connectivity via VPN, bastion hosts and DNS setup:

* Hub and Spoke, multi-regional Virtual Network architecture with Network Peering between each workload Network and the regions Hub Network
* Default routes to any on-premises locations
* 3 layer subnet structure (Public, Application, and Data), with no connectivity between the Public layer and the Data layer using Network Security Groups
* Private DNS zones managed through Azure DNS, and forwarders in place for DNS resolution to and from on-premises

![DNS resolution](images/dns.png)

## Development
![Development](images/development.png)
Automation through software defined infrastructure, continuous integration and deployment pipelines:

* Azure DevOps Project with CI/CD pipeline to continuously deploy and test solution as it is being enhanced in the future.
* Terragrunt framework for managing environment configuration
* Detailed documentation on the platform and how to change included components.

## Security
Apply best practice security and compliance - including IAM, central monitoring and logging, and notifications:

* Azure Policy set assigned for commonly used policies (Tagging, Region, Encryption etc.) to ensure a secure environment and guardrails for safe use
* Bastion Host deployed to Hub network to provide a single point for access to servers and services
* Default role based access control structure, with Owner, Contributor, and Reader roles
* Azure Network Watcher for Networking diagnostics attached to each network component and security group, shipping flow logs to central compliance account
* Azure Advisor and Azure Security Center (free) turned on by default

## Operations
Visibility and archival of platform activity:

* Centralised Logging using Log Analytics - Activity Logs shipped to centralised location for single pane of glass
* Compliance environment for a safe central audit log of all changes and logs in the azure environment.
* Azure Monitor Diagnostics (Logs and Metrics) enabled for all deployed resources
