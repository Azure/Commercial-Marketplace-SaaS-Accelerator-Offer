#! /bin/bash 

landingPageAppRegName="${webappprefix}-LandingPage"
fulfillmentAppRegName="${webappprefix}-Fulfillment"
portalWebApp="https://${webappprefix}-portal.azurewebsites.net"
portalWebAppHome="https://${webappprefix}-portal.azurewebsites.net/Home/Index"
portalWebAppLogout="https://${webappprefix}-portal.azurewebsites.net/logout"
adminWebApp="https://${webappprefix}-admin.azurewebsites.net"
adminWebAppHome="https://${webappprefix}-admin.azurewebsites.net/Home/Index"


echo "Creating Landing Page Auth App registration..."
landingPageAppId=$(\
az rest --method POST \
		--headers "Content-Type=application/json" \
		--uri https://graph.microsoft.com/v1.0/applications \
		--body "{'displayName':'$landingPageAppRegName','api':{'requestedAccessTokenVersion':2},'signInAudience':'AzureADandPersonalMicrosoftAccount','web':{'redirectUris':['$portalWebApp','$portalWebAppHome','$adminWebApp','$adminWebAppHome'],'logoutUrl':'$portalWebAppLogout','implicitGrantSettings':{'enableIdTokenIssuance':true}},'requiredResourceAccess':[{'resourceAppId':'00000003-0000-0000-c000-000000000000','resourceAccess':[{'id':'e1fe6dd8-ba31-4d61-89e7-88639da4683d','type':'Scope'}]}]}" \
		--query appId \
		--output tsv)
echo $landingPageAppId

echo "Creating API Fulfilment App registration..."
#this won't work for some reasons - no logs, no display nothing.
fulfillmentAppId=$(\
az ad app create \
		--only-show-errors \
		--display-name $fulfillmentAppRegName \
		--query appId \
		--output tsv)
echo $fulfillmentAppId

echo "Creating API Fulfilment App Secret..."
fulfillmentAppSecret=$(\
az ad app credential reset \
		--id $fulfillmentAppId \
		--append \
		--only-show-errors \
		--display-name 'SaaSAPI' \
		--years 2 \
		--query password \
		--output tsv)
echo "Created Secret!"

echo "{'landingPageAppId':'$landingPageAppId','fulfillmentAppId':'$fulfillmentAppId','fulfillmentAppSecret':'$fulfillmentAppSecret'}" > $AZ_SCRIPTS_OUTPUT_PATH
