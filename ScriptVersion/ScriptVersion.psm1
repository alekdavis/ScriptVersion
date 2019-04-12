<#
.SYNOPSIS
PowerShell commandlet returning script version information.

.LINK
https://github.com/alekdavis/ScriptVersion
#>

#Requires -Version 4.0

<#
.SYNOPSIS
Returns a hash table with name-value pairs of the properties defined in the
NOTES section of the script's comment-based help header.

.DESCRIPTION
Use this function to get script's notes, such as version, copyright information,
and so on. The name-value pairs in the NOTES section must be single-line and 
separated by colons (':'), such as:

  version   : 1.2.0
  copyright : (c) My Company 2019

MAKE SURE THAT THE COMMENT HEADER IS AT THE TOP OF THE SCRIPT AND IS FOLLOWED BY 
AT LEAST ONE BLANK LINE. For additional information about the comment help header
see About Comment Based Help: SYNTAX FOR COMMENT-BASED HELP at Microsoft documentation.

.PARAMETER ScriptPath
Optional path to the script. If not specified, the calling script will be used.

.EXAMPLE
$notes = Get-ScriptVersion
Returns the contents of the NOTES section of the calling script.

.EXAMPLE
$notes = Get-ScriptVersion -ScriptPath "C:\Scripts\MyScript.ps1"
Returns the contents of the NOTES section of the specified script.

.EXAMPLE
$version = (Get-ScriptVersion)["version"]
Returns the value of the 'version' element of the NOTES section of the calling script.
#>

function Get-ScriptVersion {
    [CmdletBinding()]
    param (
        [string]
        $ScriptPath = $null,

        [string]
        $KeyValueSeparator = ':',

        [string]
        $CommentIndicator = '#'
    )

    # Allow module to inherit '-Verbose' flag.
    if (($PSCmdlet) -and (-not $PSBoundParameters.ContainsKey('Verbose'))) {
        $VerbosePreference = $PSCmdlet.GetVariableValue('VerbosePreference')
    }

    # Allow module to inherit '-Debug' flag.
    if (($PSCmdlet) -and (-not $PSBoundParameters.ContainsKey('Debug'))) {
        $DebugPreference = $PSCmdlet.GetVariableValue('DebugPreference')
    }
    
    $notes = $null
    $notes = @{}

    # If script path is missing, use the running script.
    if (!$ScriptPath) {
        # If the invoking script is a module, check the caller.
        if ($PSCmdlet) {
            $ScriptPath = $MyInvocation.PSCommandPath
        }
        else {
            $ScriptPath = $PSCommandPath
        }
    }

    # Get the .NOTES section from the script header comment.
    $notesText = (Get-Help -Full $ScriptPath).alertSet.alert.Text

    if (!$notesText) {
        return $notes
    }

    # Split the .NOTES section by lines.
    $lines = ($notesText -split '\r?\n').Trim()

    # Iterate through every line.
    foreach ($line in $lines) {
        if (!$line) {
            continue
        }

        $name  = $null
        $value = $null

        # Split line by the first colon (:) character.
        if ($line.Contains($KeyValueSeparator)) {
            $nameValue = $null
            $nameValue = @()

            $nameValue = ($line -split $KeyValueSeparator,2).Trim()

            $name = $nameValue[0]

            if ($name) {
                $name = $name.Trim()
                
                # If name starts with hash, it's a comment, so ignore.
                if ($CommentIndicator -and ($name -match "^$CommentIndicator")) {
                    continue
                }

                $value = $nameValue[1]

                if ($value) {
                    $value = $value.Trim()
                }

                if (!($notes.ContainsKey($name))) {
                    $notes.Add($name, $value)
                }
            }
        }
    }

    return $notes
}

Export-ModuleMember -Function *
