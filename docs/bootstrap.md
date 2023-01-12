# Bootstrapping Azure Cloud Foundations
These instructions will help you take your copy of the Azure Cloud Foundations repo and turn it into a secure, compliant Azure environment into which to deploy your applications.

1. Create a subscription for each environment

2. Check the values in `environments/common.yaml` and `environments/**/environment.yaml`, especially:

    * subscription IDs
    * company prefix
    * remote state storage account name (storage account names must be globally unique)
    * contact information and other tags

3. Create the storage account and container that Terraform remote state will be stored in (as specified in `common.yaml`).

4. Obtain a service principal with the following permissions:

    * `Owner` on each subscription
    * `Directory.Read.All` on the Azure AD Graph API (as distinct from "Microsoft Graph API")
      * Make sure you select "Application permission" and not "Delegated permission"
      * Please also remember to click the "Grant admin consent for <tenant name>" button!
    * Roles on the tenant root management group (see the following step).

5. Configure your AAD tenant and service principal to work management groups:

    * While logged into the Azure portal as a user with Global Administrator role on the AAD tenant, open the AAD tenant and go to the "Properties" section. Scroll down to "Access management for Azure resources" and flick the switch to "Yes". This will grant you the User Access Administrator role on the tenant's root management group ("Tenant Root Group"), which is normally invisible through the portal.
    * Go to the Management Groups section of the portal, find the "Tenant Root Group", and add the "Management Group Contributor" and "Resource Policy Contributor" roles for your service principal.

6. Set the following environment variables:

    * `ARM_SUBSCRIPTION_ID`: Compliance subscription ID
    * `ARM_CLIENT_ID`: Service principal client ID (the service principal's "object ID" in Azure Active Directory)
    * `ARM_CLIENT_SECRET`: Service principal client secret (password)
    * `ARM_TENANT_ID`: The GUID of your Azure AD tenant

7. Deploy the tenant-wide configuration: `make apply-all DIRECTORY=environments/tenancy`

    * NOTE: It may take up to 30 minutes for Azure to fully record the movement of a subscription into a management group, and so `environments/tenancy/global/policy` may fail with an error stating that "Policy definitions should be specified only at or above the policy assignment scope." If this occurs, wait 30 minutes and then re-run the apply.

8. Deploy the compliance environment: `make apply-all DIRECTORY=environments/compliance`

9. Deploy other environments: `make apply-all`
