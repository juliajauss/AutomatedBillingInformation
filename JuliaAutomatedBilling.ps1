#Create Certificate
# makecert -r -pe -len 2048 -a sha512 -h 0 -sky signature -ss My -n "CN=JuliasCertificate" "C:\JuliasCertificate.cer"

$azureADTenantID = "c015601b-39cc-441b-a15b-5c303614de5f"  #You get this from "View Endpoints"
$subscriptionID = "00dd302a-92a9-4ec6-a567-555b1bb1fad1"   #You get this under "Settings"
$manualBillingAdmin = "Admin@juliabilling.onmicrosoft.com" #I created a new user in my Default Directory and added it under "Settings" > "Administrators" as Admin
$certificateFile = "C:\JuliasCertificate.cer"

#Specify params for creating your Azure AD Application
$appName = "JuliaBillingBlog"
$dummyUrl = "http://JuliaBillingBlog"

#Create a X509 Certificate from your created Certificate
$certOctets = Get-Content -Path $certificateFile -Encoding Byte
$credValue = [System.Convert]::ToBase64String($certOctets)
$cer = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList @(,[System.Byte[]]$certOctets)

#Login as a Subscription Administrator 
$credential = Get-Credential -UserName $manualBillingAdmin -message "Provide your organizational credentials for $($manualBillingAdmin)"
Login-AzureRmAccount -Tenant $azureADTenantID -SubscriptionId $subscriptionID -Credential $credential
Select-AzureRmSubscription -SubscriptionId $subscriptionID
# Caveat: Microsoft Account with 2FA does not work: https://support.microsoft.com/en-us/kb/2929554
Connect-MsolService -Credential $credential

#Programmatically create your Azure AD Application
$application = New-AzureRmADApplication -DisplayName $appName -HomePage $dummyUrl -IdentifierUris $dummyUrl -KeyType AsymmetricX509Cert -KeyValue $credValue
Start-Sleep -Seconds 1

#Create a Service Principal for your Azure AD Application
New-AzureRmADServicePrincipal -ApplicationId $application.ApplicationId
Start-Sleep -Seconds 1
New-AzureRmRoleAssignment  -ServicePrincipalName $application.ApplicationId -RoleDefinitionName Contributor

Write-Host "Use clientID == $($application.ApplicationID)"