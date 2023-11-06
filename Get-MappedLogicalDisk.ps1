<#
.SYNOPSIS
    GetMappedLogicalDisk - pobiera list� zamapowanych przez u�ytkownika dysk�w sieciowych
.DESCRIPTION
    
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.EXAMPLE
    GetMappedLogicalDisk -computerName CONTOSO-PC -userName USER1
    Pobiera z komputera CONTOSO-PC list� zamapowanych przez u�ytkownika USER1 dysk�w sieciowych
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