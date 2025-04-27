# New Enhanced_Security_Check_Script.ps1 (English, Clean UTF-8)

Write-Host "Starting enhanced security check..." -ForegroundColor Cyan

function Check-RegistryValue($Path, $Name, $ExpectedValue, $MessageWhenGood, $MessageWhenBad) {
    try {
        $actual = (Get-ItemProperty -Path $Path -ErrorAction Stop).$Name
        if ($actual -eq $ExpectedValue) {
            Write-Host "[$MessageWhenGood] OK" -ForegroundColor Green
        } else {
            Write-Host "[$MessageWhenBad] ERROR (Found: $actual)" -ForegroundColor Red
        }
    } catch {
        Write-Host "[$MessageWhenBad] ERROR Not Found" -ForegroundColor Red
    }
}

# 1. NetBIOS
Write-Host "\nChecking NetBIOS..." -ForegroundColor Yellow
$nbtstat = nbtstat -n
if ($nbtstat -match "<00> UNIQUE") {
    Write-Host "[NetBIOS is ENABLED] ERROR Active names found" -ForegroundColor Red
} else {
    Write-Host "[NetBIOS is DISABLED] OK" -ForegroundColor Green
}

# 2. LLMNR
Write-Host "\nChecking LLMNR..." -ForegroundColor Yellow
Check-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" "EnableMulticast" 0 "LLMNR is DISABLED" "LLMNR is ENABLED"

# 3. Advertising ID
Write-Host "\nChecking Advertising ID..." -ForegroundColor Yellow
Check-RegistryValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" "Enabled" 0 "Advertising ID is DISABLED" "Advertising ID is ENABLED"

# 4. Telemetry
Write-Host "\nChecking Telemetry..." -ForegroundColor Yellow
Check-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" 0 "Telemetry is DISABLED" "Telemetry is ENABLED"

# 5. Location Services
Write-Host "\nChecking Location Services..." -ForegroundColor Yellow
Check-RegistryValue "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" "DisableLocation" 1 "Location Services are DISABLED" "Location Services are ENABLED"

# 6. DNS over HTTPS
Write-Host "\nChecking DNS over HTTPS (DoH)..." -ForegroundColor Yellow
Check-RegistryValue "HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" "EnableAutoDoH" 2 "DNS over HTTPS is ENABLED" "DNS over HTTPS is DISABLED"

# 7. SMBv1
Write-Host "\nChecking SMBv1..." -ForegroundColor Yellow
Check-RegistryValue "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" "SMB1" 0 "SMBv1 is DISABLED" "SMBv1 is ENABLED"

# 8. Remote Assistance
Write-Host "\nChecking Remote Assistance..." -ForegroundColor Yellow
Check-RegistryValue "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" "fAllowToGetHelp" 0 "Remote Assistance is DISABLED" "Remote Assistance is ENABLED"

# 9. AutoPlay/AutoRun
Write-Host "\nChecking AutoPlay/AutoRun..." -ForegroundColor Yellow
Check-RegistryValue "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" 255 "AutoPlay/AutoRun is DISABLED" "AutoPlay/AutoRun is ENABLED"

# 10. Screensaver enforcement
Write-Host "\nChecking Screensaver settings..." -ForegroundColor Yellow
Check-RegistryValue "HKCU:\Control Panel\Desktop" "ScreenSaveActive" "1" "Screensaver Activation is ENABLED" "Screensaver Activation is DISABLED"
Check-RegistryValue "HKCU:\Control Panel\Desktop" "ScreenSaverIsSecure" "1" "Screensaver Password Lock is ENABLED" "Screensaver Password Lock is DISABLED"
Check-RegistryValue "HKCU:\Control Panel\Desktop" "ScreenSaveTimeOut" "600" "Screensaver Timeout is SET to 10 minutes" "Screensaver Timeout is NOT correctly set"

# 11. Controlled Folder Access
Write-Host "\nChecking Controlled Folder Access..." -ForegroundColor Yellow
Check-RegistryValue "HKLM:\SOFTWARE\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access" "EnableControlledFolderAccess" 1 "Controlled Folder Access is ENABLED" "Controlled Folder Access is DISABLED"

Write-Host "\nEnhanced security check completed." -ForegroundColor Cyan

Read-Host "Press Enter to exit"
