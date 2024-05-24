#require 
<#
.SYNOPSIS
    GetMappedLogicalDisk - pobiera list� zamapowanych przez u�ytkownika (AD) dysk�w sieciowych
.DESCRIPTION
    Autor: S�awomir Lubas (slawek.lubas@gmail.com)
.NOTES
    
.EXAMPLE
    GetMappedLogicalDisk -computerName CONTOSO-PC -userName USER1
    Pobiera z komputera CONTOSO-PC list� zamapowanych przez u�ytkownika USER1 dysk�w sieciowych
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
        Write-Host 'U�ytkownik nie istnieje'
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
        Write-Host 'B��dna nazwa komputera'
    }
}

#Get-MappedLogicalDisk