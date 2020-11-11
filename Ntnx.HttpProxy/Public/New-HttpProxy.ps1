function New-HttpProxy {   
<#
.SYNOPSIS
Dynamically Generated API Function
.NOTES
NOT FOR PRODUCTION USE - FOR DEMONSTRATION/EDUCATION PURPOSES ONLY

The code samples provided here are intended as standalone examples.  They can be downloaded, copied and/or modified in any way you see fit.

Please be aware that all code samples provided here are unofficial in nature, are provided as examples only, are unsupported and will need to be heavily modified before they can be used in a production environment.
#>

    [CmdletBinding()]
    [OutputType()]

    param(
        # VIP or FQDN of target AOS cluster
        [Parameter(Mandatory=$true)]
        [string]
        $ComputerName,

        # Port (Default is 9440)
        [Parameter(Mandatory=$false)]
        [int16]
        $Port = 9440,

        [Parameter(Mandatory=$false)]
        [switch]
        $ShowMetadata,

        # Body Parameter1
        [Parameter()]
        [string]
        $Name,

        [Parameter()]
        [string]
        $Address,

        [Parameter()]
        [int]
        $ProxyPort,

        [Parameter()]
        [ValidateSet("HTTP","HTTPS","SOCKS")]
        [string[]]
        $ProxyTypes,

        [Parameter()]
        [pscredential]
        $ProxyCredential,

        # Prism UI Credential to invoke call
        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential
    )

    process {
        $headers = Initialize-BasicAuthHeader -credential $Credential
        $headers.Add("content-type", "application/json")

        $body = [Hashtable]::new()
        $body.add("name",$Name)
        $body.add("address",$Address)
        $body.add("port",$ProxyPort)
        $body.add("proxy_types",$ProxyTypes)

        if($null -ne $ProxyCredential){
            Write-Verbose -Message "Proxy Credential specified"
            $body.add("username",$ProxyCredential.username)
            $body.Add("password",$ProxyCredential.GetNetworkCredential().Password)
        }
        <#else{
            $body.add("username","")
            $body.Add("password","")
        }#>

        $args = @{
            Uri = "https://$($ComputerName):$($Port)/PrismGateway/services/rest/v2.0/http_proxies"
            Method = "POST"
            Headers = $headers
        }
        if($body.count -ge 1){
            $body = $body | ConvertTo-Json -Depth 20
            $args.add("Body",$body)
        }
        
        Write-Debug -Message $body

        $response = Invoke-WebRequest @args

        if($response.StatusCode -in 200..204){
            if($ShowMetadata){
                $response.Content | ConvertFrom-Json    
            }
            else{
                ($response.Content | ConvertFrom-Json).Entities
            }
        }   
        else{
            Write-Error -Message "$($response.StatusCode): $($response.StatusDescription)"
        }    

    }
                
}
