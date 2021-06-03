$OutPath = (Split-Path -path $PSScriptRoot)
$ModuleName = (Split-Path -path $OutPath -Leaf)
$Public = "$OutPath\$ModuleName\Public"

$v1Args = @{
    ApiVersion = "v1"
    OutPath = $Public
    AppendApiVersionInNoun = $true
}

New-NtnxApiFunction @v1Args -Method Get -SubUrl "http_proxies" 
New-NtnxApiFunction @v1Args -Method Get -SubUrl "http_proxies/whitelist" #-Parameters StandardNtnx 

$whitelistPutArgs = @{
    Body = @{
        whitelist = $whitelist
    }
}
New-NtnxApiFunction @v1Args -Method Put -SubUrl "http_proxies/whitelist" -AltVerb "Update" #-Parameters StandardNtnx,Whitelist -Body $whitelistPutArgs.Body
#New-NtnxApiFunction -Method Get -ApiVersion v1 -OutPath "$OutPath\$ModuleName\Public" -SubUrl "license/cluster_summary_file"