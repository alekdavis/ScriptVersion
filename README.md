# ScriptVersion.psm1
This [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/overview) module allows you to read script version information defined in the script's [NOTES section](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-6#notes).

## Cmdlet
The `ScriptVersion` module exports the following cmdlet:

- Get-ScriptVersion

### Get-ScriptVersion
Use `Get-ScriptVersion` to get a hashtable holding the file version information recorded in the script comment header's [NOTES section](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-6#notes).

#### Syntax

```PowerShell
Get-ScriptVersion `
  [-ScriptPath <string>] `
  [-KeyValueSeparator <string>],
  [-CommentIndicator <string>] `
  [<CommonParameters>]
```

#### Arguments

`-ScriptPath`

Path to the PowerShell script file. If the path is not specified, the calling script will be assumed.

`-KeyValueSeparator`

The character (or string) that separates key-value version information entries. The default value is `:`.

`-Json`

A shortcut for `-Format Json`.

`-CommentIndicator`

The string that indicates that the version entry contains a comment and should not be processed. The default value is `#`.

`-<CommonParameters>`

Common PowerShell parameters (cmdlet is not using these explicitly).

#### NOTES section
Use the script comment header's [NOTES section](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-6#notes) to define version information, such as:

```PowerShell
<#
.SYNOPSIS
Example of version information.

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
```

Please follow the [SYNTAX FOR COMMENT-BASED HELP](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-6#syntax-for-comment-based-help) rules.

#### Limitations

Key-value pairs cannot span multiple lines.

#### Usage

You can download a copy of the module from the [Github repository](ScriptVersion) or install it from the [PowerShell Gallery](https://www.powershellgallery.com/packages/ScriptVersion) (see [Examples](#Examples)).

#### Examples

##### Example 1
```PowerShell
function LoadModule {
    param(
        [string]
        $ModuleName
    )

    if (!(Get-Module -Name $ModuleName)) {

        if (!(Get-Module -Listavailable -Name $ModuleName)) {
            Install-Module -Name $ModuleName -Force -Scope CurrentUser -ErrorAction Stop
        }

        Import-Module $ModuleName -ErrorAction Stop -Force
    }
}

$modules = @("ScriptVersion")
foreach ($module in $modules) {
    try {
        LoadModule -ModuleName $module
    }
    catch {
        throw (New-Object System.Exception "Cannot load module $module.", $_.Exception)
    }
}
```
Downloads the `ScriptVersion` module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/ScriptVersion) into the PowerShell modules folder for the current user and imports it into the running script.

##### Example 2
```PowerShell
$modulePath = Join-Path (Split-Path -Path $PSCommandPath -Parent) 'ScriptVersion.psm1'
Import-Module $modulePath -ErrorAction Stop -Force
```
Imports the `ScriptVersion` module from the same directory as the running script.


##### Example 3
```PowerShell
$notes = Get-ScriptVersion
```
Returns the contents of the NOTES section of the calling script.

##### Example 4
```PowerShell
$notes = Get-ScriptVersion -ScriptPath "C:\Scripts\MyScript.ps1"
```
Returns the contents of the NOTES section of the specified script.

##### Example 5
```PowerShell
$version = (Get-ScriptVersion)["version"]
```
Returns the value of the 'version' element of the NOTES section of the calling script.
