$user = Read-Host "Enter your username"
$pswd = Read-Host  "Enter your password" -AsSecureString
$actualUser = "admin"
$actualPassword = ConvertTo-SecureString -String "password" -AsPlainText -Force

function Compare-SecureStrings
{
  <#
  .SYNOPSIS
  Safely compares two SecureString objects without decrypting them.
  .DESCRIPTION
  Safely compares two SecureString objects without decrypting them.
  Outputs $true if they are equal, or $false otherwise.
  .INPUTS
  None. You can't pipe objects to Compare-SecureStrings.
  .OUTPUTS
  System.Boolean is returned.
  .PARAMETER secureString1
  Specifies first string for comparison
  .PARAMETER secureString2
  Specifies second string for comparison
  .EXAMPLE
  PS> Compare-SecureString $entered_password $acutual_password
  false
  #>

  param(
    [Security.SecureString]
    $secureString1,

    [Security.SecureString]
    $secureString2
  )

  try {
    $bstr1 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString1)
    $bstr2 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString2)
    $length1 = [Runtime.InteropServices.Marshal]::ReadInt32($bstr1,-4)
    $length2 = [Runtime.InteropServices.Marshal]::ReadInt32($bstr2,-4)
    if ( $length1 -ne $length2 ) {
      return $false
    }
    for ( $i = 0; $i -lt $length1; ++$i ) {
      $b1 = [Runtime.InteropServices.Marshal]::ReadByte($bstr1,$i)
      $b2 = [Runtime.InteropServices.Marshal]::ReadByte($bstr2,$i)
      if ( $b1 -ne $b2 ) {
        return $false
      }
    }
    return $true

  }
  finally {
    if ( $bstr1 -ne [IntPtr]::Zero ) {
      [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr1)
    }
    if ( $bstr2 -ne [IntPtr]::Zero ) {
      [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr2)
    }
  }
}

if ($user -eq $actualUser)
{
  if (Compare-SecureStrings $pswd $actualPassword)
  {
      Write-Host "Successful login"
  }
  else
  {
      Write-Host "Incorrect password"
    }
}

else
{
    Write-Host "Wrong login"
}