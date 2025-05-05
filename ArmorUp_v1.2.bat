@echo off
:: ArmorUp Security Complete v1.2
:: Minor update: Version bump for GUI integration
:: Copyright (c) 2025 NorHackCERT
:: MIT License

:: Ensure script runs as admin
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO Please run this script as Administrator!
    PAUSE
    EXIT /B
)

ECHO =====================================================
ECHO     ArmorUp v1.2 - Windows Security Hardening Tool
ECHO =====================================================
ECHO.

:: 1. Run Windows Update
ECHO Running Windows Update...
powershell.exe -Command "Install-Module PSWindowsUpdate -Force -Confirm:$false; Import-Module PSWindowsUpdate; Get-WindowsUpdate -AcceptAll -Install -AutoReboot"

:: 2. Disable NetBIOS
ECHO Disabling NetBIOS...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "EnableProxy" /t REG_DWORD /d 0 /f >nul

:: 3. Disable LLMNR
ECHO Disabling LLMNR...
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d 0 /f >nul

:: 4. Disable Advertising ID
ECHO Disabling Advertising ID...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul

:: 5. Disable Telemetry
ECHO Disabling Telemetry...
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul

:: 6. Disable Location Services
ECHO Disabling Location Services...
reg add "HKLM\Software\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d 1 /f >nul

:: 7. Enable DNS over HTTPS (DoH)
ECHO Enabling DNS over HTTPS (DoH)...
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "EnableAutoDoh" /t REG_DWORD /d 2 /f >nul

:: 8. Disable SMBv1
ECHO Disabling SMBv1...
dism /online /norestart /disable-feature /featurename:SMB1Protocol

:: 9. Disable Remote Assistance
ECHO Disabling Remote Assistance...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f >nul

:: 10. Disable AutoPlay/AutoRun
ECHO Disabling AutoPlay/AutoRun...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d 1 /f >nul

:: 11. Configure Screensaver Lock
ECHO Configuring Screensaver with Password Lock...
reg add "HKCU\Control Panel\Desktop" /v "ScreenSaveActive" /t REG_SZ /d "1" /f >nul
reg add "HKCU\Control Panel\Desktop" /v "ScreenSaverIsSecure" /t REG_SZ /d "1" /f >nul
reg add "HKCU\Control Panel\Desktop" /v "ScreenSaveTimeOut" /t REG_SZ /d "600" /f >nul

:: Enable Controlled Folder Access
ECHO Enabling Controlled Folder Access...
powershell.exe -Command "Set-MpPreference -EnableControlledFolderAccess Enabled" >nul 2>&1

ECHO =====================================================
ECHO ArmorUp v1.2 hardening complete. Please reboot your PC!
ECHO =====================================================
PAUSE
