#require 
<#
.SYNOPSIS
    GetMappedLogicalDisk - pobiera listê zamapowanych przez u¿ytkownika (AD) dysków sieciowych
.DESCRIPTION
    Autor: S³awomir Lubas (slawek.lubas@gmail.com)
.NOTES
    
.EXAMPLE
    GetMappedLogicalDisk -computerName CONTOSO-PC -userName USER1
    Pobiera z komputera CONTOSO-PC listê zamapowanych przez u¿ytkownika USER1 dysków sieciowych
#>
function Get-MappedLogicalDisk {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][String]$computerName,
        [Parameter(Mandatory)][String]$userName
    )
    try {
        [String]$SID = $(Get-ADUser -Identity $userName).SID      
    }
    catch {
        Write-Host 'U¿ytkownik nie istnieje'
        return
    }
    if (Test-Connection -ComputerName $computerName -Count 1 -ErrorAction SilentlyContinue)
    {
        $scriptBlock = {
            $NetworkKey = 'Registry::HKEY_USERS\' + $Using:SID + '\Network\'
            $MappedDrive = Get-ChildItem -Path $NetworkKey|Get-ItemProperty
            return $MappedDrive 
        }
        $drive = Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock
        $drive
    }
    else {
        Write-Host 'B³êdna nazwa komputera'
    }
}

#Get-MappedLogicalDisk