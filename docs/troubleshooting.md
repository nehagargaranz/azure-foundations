# Troubleshooting guide

You can usually solve your problem by copy-pasting the error message into Google, but you may find a more Foundations-specific solution quicker in this file.

## Error 403 due to policy
Azure Policy error messages are notoriously difficult to read. They contain JSON-encoded JSON, with no linebreaks. However, if you persist and parse the whole thing (e.g. copy-paste into `jq`) then it will tell you exactly what properties it was looking at on which resources.

## Change in management groups not being reflected in portal and/or CLI output
Changes to management groups (e.g. moving a subscription) can take up to 30 minutes to appear.

## Azure Policy enforcing a policy that no longer exists / is not enforcing a new policy
Azure Policy changes take up to 60 minutes to take effect. Sometimes this means you have to wait if you want to delete a policy definition and put up a new policy definition with the same name.

## "Provider produced inconsistent plan"
You can ignore this error. If the run failed, it was because of a different error elsewhere. This error is not fatal. All it is saying is that the Terraform provider's bookkeeping was sloppy.

If you are feeling community-spirited, and you can reproduce the error message without involving sensitive information, then you can submit a bug report to the provider (e.g. azurerm).

## Error locking state: Error acquiring the state lock
Terraform acquires a lock when accessing your state to prevent others running Terraform to potentially modify the state at the same time. An error occurred while releasing this lock. This could mean that the lock did or did not release properly.

The solution to this is to ensure that no other terraform processes are running, that may mean the lock is valid. If the lock is invalid, you may unlock the state file by hand:

1. The path to the state file should be present in the output; e.g. `Path: tfstate/dev/australiaeast/vnet-spoke/terraform.tfstate`.
2. Unlock the state blob in the Azure Storage Account.
    * Locate the state blob within the Terraform state Storage Account using the Azure Portal; and click **Break Lease**
    * Use the `az` cli to break the lease, giving the `--blob-name`, `--container-name`, and `--account-name`: See [az storage blob lease break](https://docs.microsoft.com/en-us/cli/azure/storage/blob/lease?view=azure-cli-latest#az-storage-blob-lease-break)
