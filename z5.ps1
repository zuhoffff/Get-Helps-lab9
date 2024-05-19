<#
  .SYNOPSIS
  Displays some info about the device (time, system versino, username, ip)

  .DESCRIPTION
  Displays some info about the device (time, system versino, username, ip)

  .INPUTS
  None. You can't pipe objects to Update-Month.ps1.

  .OUTPUTS
  None. Update-Month.ps1 doesn't generate any output.

  .EXAMPLE
  PS> .\z5.ps1
    Current date on lenovo :05/19/2024 12:19:36
    Current system version on lenovo : 10.0.22631
    Current  user is: Administrator DefaultAccount Guest snick WDAGUtilityAccount
    Current ipv4 on lenovo is: 192.168.56.1
#>


function Get-Device-Date
{
    param(
        [string] $device
    )
    Write-Host "Current date on $device :$(Get-Date)"
}

function Get-Device-Version
{
    param(
        [string] $device
    )
    $ofInfo = Get-CimInstance Win32_OperatingSystem
    $osInfo = $ofInfo.Version
    Write-Host "Current system version on $device : $osInfo"
}

function Get-Device-User
{
    param(
        [string] $device
    )
    Write-Host "Current $deivce user is: $(Get-LocalUser)"
}

function Get-Device-IP
{
    param(
        [string] $device
    )
    $ipconfigOutput = ipconfig
    $ipAddress = ($ipconfigOutput | Where-Object {$_ -match 'IPv4 Address'}).Split(':')[-1].Trim()
    Write-Host "Current ipv4 on $device is: $ipaddress"
}

Get-Device-Date lenovo
Get-Device-Version lenovo
Get-Device-User lenovo
Get-Device-IP lenovo