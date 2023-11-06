<#
.SYNOPSIS
    GetMappedLogicalDisk - pobiera listê zamapowanych dysków sieciowych
.DESCRIPTION
    
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>
function Get-MappedLogicalDisk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][String[]]$computerName,
        [Parameter(Mandatory)][String]$userName
    )
    [String]$SID = $(Get-ADUser -Identity $userName).SID  
    $scriptBlock = {
        $NetworkKey = 'Registry::HKEY_USERS\' + $Using:SID + '\Network\'
        $MappedDrive = Get-ChildItem -Path $NetworkKey|Get-ItemProperty
        return $MappedDrive 
    }
    $drive = Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock
    $drive
}