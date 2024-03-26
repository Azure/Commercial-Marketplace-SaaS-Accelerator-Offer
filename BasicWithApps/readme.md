Run this in CloudShell (or local AZ CLI enabled PowerShell instance) before deployment.

```
curl https://raw.githubusercontent.com/Azure/Commercial-Marketplace-SaaS-Accelerator-Offer/main/BasicWithApps/identity.ps1 -o identity.ps1
./identity.ps1 -n <name> -g <resource-group> -l <location>
```

It is safe to remove the <resource-group> after the Marketplace Offer is deployed.