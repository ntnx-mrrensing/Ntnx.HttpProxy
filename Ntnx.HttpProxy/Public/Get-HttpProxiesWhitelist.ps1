function Get-HttpProxiesWhitelist {   
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

        # Skip SSL cert check
        [Parameter()]
        [switch]
        $SkipCertificateCheck,

        # Prism UI Credential to invoke call
        [Parameter(Mandatory=$true)]
        [PSCredential]
        $Credential
    )

    process {
        #$headers = Initialize-BasicAuthHeader -credential $Credential
        $headers.Add("content-type", "application/json")

        #$body = [Hashtable]::new()
        #$body.add("BodyParam1",$BodyParam1)

        $iwrArgs = @{
            Uri = "https://$($ComputerName):$($Port)/PrismGateway/services/rest/v1/http_proxies/whitelist"
            Method = "GET"
            Headers = $headers
        }

        if ($PSVersionTable.PSVersion.Major -lt 6) {
            $basicAuth = Initialize-BasicAuthHeader -Credential $Credential
            $iwrArgs.Add("headers",$basicAuth)
        }
        else{
            $iwrArgs.add("Authentication","Basic")
            $iwrArgs.add("Credential",$Credential)
            $iwrArgs.add("SslProtocol","Tls12")

            if ($SkipCertificateCheck) {
                $iwrArgs.add("SkipCertificateCheck",$true)
            }
        }

        if ($SkipCertificateCheck) {
            $iwrArgs.add("SkipCertificateCheck",$true)
        }

        if($body.count -ge 1){
            $args.add("Body",($body | ConvertTo-Json))
        }
        
        $response = Invoke-WebRequest @iwrArgs

        if($response.StatusCode -eq 200){
                $response.Content | ConvertFrom-Json    
        }   
        else{
            Write-Error -Message "$($response.StatusCode): $($response.StatusDescription)"
        }    

    }
                
}
