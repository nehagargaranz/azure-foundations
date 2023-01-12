{
  "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.Security/pricings",
      "apiVersion": "2018-06-01",
      "name": "${resourceType}",
      "properties": {
        "pricingTier": "${pricingTier}"
      }
    }
  ],
  "outputs": {}
}
