<#
.SYNOPSIS
Example of script using the ScriptVersion module to display script version info.

.NOTES
Version    : 1.0.0
Author     : Alek Davis
Created on : 2019-04-10
License    : MIT License
LicenseLink: https://github.com/alekdavis/ScriptVersion/blob/master/LICENSE
Copyright  : (c) 2019 Alek Davis

.LINK
https://github.com/alekdavis/ScriptVersion
#>

<#
MAKE SURE THAT THE SCRIPT STARTS WITH THE HELP COMMENT HEADER AND THE HEADER IS 
FOLLOWED BY AT LEAST ONE BLANK LINE; OTHERWISE, THE COMMANDLET WILL NOT WORK.
#>

[CmdletBinding()]
param ()

$modulePath = Join-Path (Join-Path (Split-Path -Path $PSCommandPath -Parent) 'ScriptVersion') 'ScriptVersion.psm1'
Import-Module $modulePath -ErrorAction Stop -Force

$versionInfo = Get-ScriptVersion

foreach ($key in $versionInfo.Keys) {
    Write-Host ("$key = " + $versionInfo[$key])
}
