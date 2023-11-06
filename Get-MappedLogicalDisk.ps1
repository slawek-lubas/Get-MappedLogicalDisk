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
    write-host $SID

    $scriptBlock = {
        New-PSDrive  -Name 'HKU' -PSProvider 'Registry' -Root 'HKEY_USERS'
        $NetworkKey = 'HKU:\' + $Using:SID + '\Network\'
        $MappedDrive = Get-ChildItem -Path $NetworkKey
        return $MappedDrive 
    }


    $drive = Invoke-Command -ComputerName $computerName -ScriptBlock $scriptBlock
    $drive
    # Get-ChildItem
    # Get-ItemProperty
}