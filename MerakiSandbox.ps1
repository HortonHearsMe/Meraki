# Force the connection to use TLS 1.2.  By default Powershell uses TLS 1.0, and this will fail.
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

<#Set variables
If needed, I will tag the scripts to show which variable they provide.  If you do not know your variables, run the script, find the next variable in the output,
and fill it in this variable section.
The only variable that you must have at first, is the $apiKey.  This is available from the Meraki Dashboard by doing the following:
1) Enable API access at Organization/Settings/"Dashboard API Access"
2) Retrieve your API key at the Meraki Dashboard, your username (top right), My Profile, "API Access"  You can only have 1 API key per user at a time.
If you lose your API key, you will need to regenerate a new one.
#>
    #The $apiKey is unique to each user, and will provide rights based on that users authorization level (Global/Network specific, Administrator/ReadOnly.
    $apiKey='093b24e85df15a3e66f1fc359f4c48493eaa1b73'
    
    #The $oganizationId is the unique identifier for your Organization in the Meraki cloud.
    $organizationId='537758'

    #The $networkId will be unique for each network, and corresponds to the networks as listed in the Meraki dahsboard drop-down.
    $networkId='L_646829496481100388'

    #The $ssidNum is the number assigned to the SSID that you want to query.
    $ssidNum='3'

    #The $shard is the 4 digit preamble at the start of the web address for your specific portal.  Not every call needs the shard, but some do.
    $shard=''

    #The $path variable will prompt the user to enter a directory path where files will be saved (c:\scripts\Meraki\).
    $path = Read-Host -Prompt 'Enter the directory where files will be saved:'

<#
Organization Level Reports
#>
#Retrieve Organizations
#This step will display the $organizationId used in subsequent requests.
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/organizations `
    | Export-Clixml $path\MerakiOrganization.xml

#Retrieve adminis of the Organization
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/organizations/$organizationId/admins `
    | Export-Clixml $path\MerakiAdmins.xml

#Retrieve license information for the Organization
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/organizations/$organizationId/licenseState `
    | Export-Clixml $path\MerakiLicenses.xml

#Retrieve inventory information for the Organization
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/organizations/$organizationId/inventory `
    | Export-Clixml $path\MerakiInventory.xml

<#
Network Level Reports
#>
#Retrieve a list of networks for the Organization
#This step will display the the $networkId variable used in subsequent requests.
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/organizations/$organizationId/networks `
    | Export-Clixml $path\MerakiNetworks.xml

#Retrieve the specified Network
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/networks/$networkId `
    | Export-Clixml $path\MerakiNetName.xml

#Retrieve access policies for the specified Network
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/networks/$networkId/accessPolicies `
    | Export-Clixml $path\MerakiAccessPolicies.xml

#Retrieve a list of Meraki Devices for the Network (Similar to 'Inventory') but with a little more information
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/networks/$networkId/devices `
    | Export-Clixml $path\MerakiDevices.xml

#Retrieves static routes for the network
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/networks/$networkId/staticRoutes `
    | Export-Clixml $path\MerakiStaticRoute.xml

#Retrieve a list of SSIDs
#This step will display the "number" which is used for the $ssidNum variable
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/networks/$networkId/ssids `
    | Export-Clixml $path\MerakiSSIDs.xml

<#
Firewall Level Reports
#>
#Retrieves Layer3 Firewall rule from the Security Appliance (MX units)
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/networks/$networkId/l3FirewallRules `
    | Export-Clixml $path\MerakiMxL3Firewall.xml

#Retrieves Layer3 Firewall rule for the designated SSID (MR units)
Invoke-RestMethod -ContentType application/json -Headers @{'X-Cisco-Meraki-API-Key'=$apiKey} `
    -Uri https://dashboard.meraki.com/api/v0/networks/$networkId/ssids/$ssidNum]/l3FirewallRules `
    | Export-Clixml $path\MerakiSsidL3Firewall.xml


<#
Concatonate files into one for easy doc-compare:
#>
#The $outfile variable will prompt the user to set the name for the concatanated file.  
$outfile = Read-Host -Prompt 'Enter a name for the concatanated file (file will be written to the above location)'
Get-ChildItem -Path $path -Filter "Meraki*.xml" | Get-Content | Add-Content -Path  $path\$outfile



<#
Helpful Links:
https://documentation.meraki.com/zGeneral_Administration/Other_Topics/The_Cisco_Meraki_Dashboard_API
https://documenter.getpostman.com/view/897512/meraki-dashboard-api/2To9xm#intro
#>