@echo off

REM --- ArmorUp_Security_Complete.bat ---
REM Combines system update and security fixes into one script

echo.
echo Starting system update and security enhancements...
echo.

REM Run Windows Update using built-in UsoClient
echo Checking for updates...
UsoClient StartScan

echo Waiting briefly to allow scan to complete...
timeout /t 10 /nobreak

echo Downloading updates...
UsoClient StartDownload


echo Installing updates...
UsoClient StartInstall

REM --- Apply Security Fixes ---
echo.
echo Applying additional security hardening...

REM 1. Disable SMBv1
sc.exe config lanmanworkstation depend=bowser/mrxsmb20/nsi
sc.exe config mrxsmb10 start= disabled
REG ADD "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 0 /f

REM 2. Disable Remote Assistance
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f

REM 3. Disable AutoPlay/AutoRun
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f

REM 4. Enable Screensaver Password Lock
REG ADD "HKCU\Control Panel\Desktop" /v ScreenSaverIsSecure /t REG_SZ /d 1 /f

REM 5. Set Screensaver Timeout to 10 minutes (600 seconds)
REG ADD "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 600 /f

REM --- Done ---
echo.
echo System update initiated and security settings fixed.
echo Please allow Windows to complete updates in the background and reboot your computer to apply all changes.
pause
exit
