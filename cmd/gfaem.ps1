Param(
    [parameter(Mandatory=$true,
    HelpMessage="Enter AEM user")]
    [String]
    $User,
    [parameter(Mandatory=$true,
    HelpMessage="Enter AEM password")]
    [String]
    $Pass,
    [parameter(Mandatory=$true,
    HelpMessage="Enter AEM instance URL")]
    [String]
    $Uri
)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls

$username = $User
$password = ConvertTo-SecureString –String $Pass –AsPlainText -Force
$credential = New-Object –TypeName "System.Management.Automation.PSCredential" –ArgumentList $username, $password
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))
$getProjectUri = $Uri
$heads = @{
    Authorization = "Basic $base64AuthInfo"
#    Referer = 'rbose'
#    Host = 'localhost:4502'
    'User-Agent' = 'curl/7.45.0'
    Accept = 'application/json'
}
$params = @{'transportUser' = 'admin'}
Invoke-RestMethod -Method POST -Uri $getProjectUri -Headers $heads -Credential $credential -Body $params -UseBasicParsing
Invoke-RestMethod -Method Get -Uri "${getProjectUri}.json" -Headers $heads -Credential $credential -ContentType "application/json" -UseBasicParsing
