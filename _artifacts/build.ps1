 git clone https://github.com/Azure/Commercial-Marketplace-SaaS-Accelerator.git -b 7.5.1 --depth 1;
 cd ./Commercial-Marketplace-SaaS-Accelerator/deployment;
 dotnet publish ../src/AdminSite/AdminSite.csproj -c release -o ../Publish/AdminSite/
 dotnet publish ../src/MeteredTriggerJob/MeteredTriggerJob.csproj -c release -o ../Publish/AdminSite/app_data/jobs/triggered/MeteredTriggerJob/ -v q --runtime win-x64 --self-contained true
 dotnet publish ../src/CustomerSite/CustomerSite.csproj -c release -o ../Publish/CustomerSite/
 Compress-Archive -Path ../Publish/AdminSite/* -DestinationPath ../Publish/AdminSite.zip -Force
 Compress-Archive -Path ../Publish/CustomerSite/* -DestinationPath ../Publish/CustomerSite.zip -Force

  ## Set Connectionstring
$Connection="Data Source=tcp:"+$ServerUri+",1433;Initial Catalog="+$SQLDatabaseName+";User Id="+$SQLAdminLogin+"@"+$SQLServerName+".database.windows.net;Password="+$SQLAdminLoginPassword+";"
Set-Content -Path ../src/AdminSite/appsettings.Development.json -value "{`"ConnectionStrings`": {`"DefaultConnection`":`"$Connection`"}}"
dotnet-ef migrations script  --output script.sql --idempotent --context SaaSKitContext --project ../src/DataAccess/DataAccess.csproj --startup-project ../src/AdminSite/AdminSite.csproj