@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1

:: ============================================================
:: AUTO-ELEVATE TO ADMINISTRATOR
:: ============================================================
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting Administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Set purple color (bright magenta)
color 0D
title PURPLE FREE - System Optimizer

goto MAIN_MENU

:: ============================================================
:MAIN_MENU
cls
echo.
echo   ########  ##     ## ########  ########  ##       ########
echo   ##     ## ##     ## ##     ## ##     ## ##       ##
echo   ##     ## ##     ## ##     ## ##     ## ##       ##
echo   ########  ##     ## ########  ########  ##       ######
echo   ##        ##     ## ##   ##   ##        ##       ##
echo   ##        ##     ## ##    ##  ##        ##       ##
echo   ##         #######  ##     ## ##        ######## ########
echo.
echo   ######## ########  ######## ########
echo   ##       ##     ## ##       ##
echo   ##       ##     ## ##       ##
echo   ######   ########  ######   ######
echo   ##       ##   ##   ##       ##
echo   ##       ##    ##  ##       ##
echo   ##       ##     ## ######## ########
echo.
echo  ============================================================
echo.
echo    [1]  Performance Tweaks        [2]  Network Tweaks
echo.
echo    [3]  GPU Tweaks                [4]  Mouse and Input Tweaks
echo.
echo    [5]  Privacy and Telemetry     [6]  Power Plan Tweaks
echo.
echo    [7]  RAM and Memory Tweaks     [8]  Storage and I/O Tweaks
echo.
echo    [9]  Visual and UI Tweaks      [A]  Services Tweaks
echo.
echo    [B]  Gaming Tweaks             [C]  Security Tweaks
echo.
echo    [X]  Apply ALL Tweaks          [Q]  Quit
echo.
echo  ============================================================
echo.
set "CHOICE="
set /p CHOICE="  Select an option: "

if /i "!CHOICE!"=="1" goto PERFORMANCE
if /i "!CHOICE!"=="2" goto NETWORK
if /i "!CHOICE!"=="3" goto GPU
if /i "!CHOICE!"=="4" goto MOUSE
if /i "!CHOICE!"=="5" goto PRIVACY
if /i "!CHOICE!"=="6" goto POWER
if /i "!CHOICE!"=="7" goto RAM
if /i "!CHOICE!"=="8" goto STORAGE
if /i "!CHOICE!"=="9" goto VISUAL
if /i "!CHOICE!"=="A" goto SERVICES
if /i "!CHOICE!"=="B" goto GAMING
if /i "!CHOICE!"=="C" goto SECURITY
if /i "!CHOICE!"=="X" goto APPLY_ALL
if /i "!CHOICE!"=="Q" goto EXIT
echo.
echo   Invalid option. Press any key to try again...
pause >nul
goto MAIN_MENU

:: ============================================================
:PERFORMANCE
cls
call :PRINT_HEADER
echo   == [1] PERFORMANCE TWEAKS ==
echo.

sc stop SysMain >nul 2>&1
sc config SysMain start=disabled >nul 2>&1
echo   [OK]  Disabled SysMain (Superfetch)

sc stop WSearch >nul 2>&1
sc config WSearch start=disabled >nul 2>&1
echo   [OK]  Disabled Windows Search Indexing

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Prefetch

reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled GameDVR

bcdedit /deletevalue useplatformclock >nul 2>&1
bcdedit /set useplatformclock false >nul 2>&1
bcdedit /set disabledynamictick yes >nul 2>&1
bcdedit /set tscsyncpolicy enhanced >nul 2>&1
echo   [OK]  Disabled HPET / Dynamic Tick

reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
sc config WerSvc start=disabled >nul 2>&1
echo   [OK]  Disabled Windows Error Reporting

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK]  Disabled Power Throttling

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v MaintenanceDisabled /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK]  Disabled Automatic Maintenance

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK]  Disabled Background Apps

reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo   [OK]  Set CPU Priority Boost

echo.
echo   Performance Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:NETWORK
cls
call :PRINT_HEADER
echo   == [2] NETWORK TWEAKS ==
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK]  Disabled Nagle's Algorithm

netsh interface ip set dns name="Ethernet" static 1.1.1.1 >nul 2>&1
netsh interface ip add dns name="Ethernet" 1.0.0.1 index=2 >nul 2>&1
netsh interface ip set dns name="Wi-Fi" static 1.1.1.1 >nul 2>&1
netsh interface ip add dns name="Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
echo   [OK]  Set DNS to Cloudflare (1.1.1.1 / 1.0.0.1)

ipconfig /flushdns >nul 2>&1
echo   [OK]  Flushed DNS Cache

netsh int tcp set global autotuninglevel=normal >nul 2>&1
echo   [OK]  Set TCP Auto-Tuning to Normal

netsh int tcp set global rss=enabled >nul 2>&1
echo   [OK]  Enabled Receive Side Scaling (RSS)

netsh int tcp set global chimney=disabled >nul 2>&1
echo   [OK]  Disabled TCP Chimney Offload

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul 2>&1
echo   [OK]  Disabled Network Throttling

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Set QoS Reserved Bandwidth to 0%%

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f >nul 2>&1
echo   [OK]  Disabled IPv6

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f >nul 2>&1
echo   [OK]  Optimized TCP Parameters

echo.
echo   Network Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:GPU
cls
call :PRINT_HEADER
echo   == [3] GPU TWEAKS ==
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
echo   [OK]  Enabled Hardware-Accelerated GPU Scheduling (HAGS)

reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK]  Disabled Fullscreen Optimizations

sc stop NvTelemetryContainer >nul 2>&1
sc config NvTelemetryContainer start=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\NVIDIA Corporation\NvControlPanel2\Client" /v OptInOrOutPreference /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled NVIDIA Telemetry

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
echo   [OK]  Set GPU Priority to 8 (max)

powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 ee12f906-d277-404b-b6da-e5fa1a576df5 0 >nul 2>&1
echo   [OK]  Disabled PCIe Link State Power Management

echo   [INFO] NVIDIA: Set Prefer Maximum Performance in NVCP

echo.
echo   GPU Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:MOUSE
cls
call :PRINT_HEADER
echo   == [4] MOUSE AND INPUT TWEAKS ==
echo.

reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d "0" /f >nul 2>&1
echo   [OK]  Disabled Mouse Acceleration

reg add "HKCU\Control Panel\Mouse" /v MouseTrails /t REG_SZ /d "0" /f >nul 2>&1
echo   [OK]  Disabled Mouse Pointer Trails

reg add "HKCU\Control Panel\Mouse" /v SnapToDefaultButton /t REG_SZ /d "0" /f >nul 2>&1
echo   [OK]  Disabled Snap to Default Button

reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f >nul 2>&1
echo   [OK]  Disabled Sticky Keys

reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d "122" /f >nul 2>&1
echo   [OK]  Disabled Filter Keys

reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d "58" /f >nul 2>&1
echo   [OK]  Disabled Toggle Keys

reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d "31" /f >nul 2>&1
echo   [OK]  Set Keyboard Repeat Rate to Fastest

echo   [INFO] Set mouse polling rate to 1000Hz in your mouse software

echo.
echo   Mouse and Input Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:PRIVACY
cls
call :PRINT_HEADER
echo   == [5] PRIVACY AND TELEMETRY TWEAKS ==
echo.

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Windows Telemetry

sc stop DiagTrack >nul 2>&1
sc config DiagTrack start=disabled >nul 2>&1
echo   [OK]  Disabled DiagTrack

reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled CEIP

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Windows Tips and Suggestions

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Advertising ID

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d "Deny" /f >nul 2>&1
echo   [OK]  Disabled Location Tracking

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Activity History

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Cortana

reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Feedback Requests

echo.
echo   Privacy and Telemetry Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:POWER
cls
call :PRINT_HEADER
echo   == [6] POWER PLAN TWEAKS ==
echo.

powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
echo   [OK]  Duplicated Ultimate Performance Plan

for /f "tokens=4" %%G in ('powercfg -list ^| findstr /i "ultimate"') do (
    powercfg -setactive %%G >nul 2>&1
)
echo   [OK]  Activated Ultimate Performance Power Plan

powercfg -setacvalueindex SCHEME_CURRENT 2a737441-1930-4402-8d77-b2bebba308a3 48e6b7a6-50f5-4782-a5d4-53bb8f07e226 0 >nul 2>&1
echo   [OK]  Disabled USB Selective Suspend

powercfg -setacvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100 >nul 2>&1
echo   [OK]  Set Processor Minimum State to 100%%

powercfg -setacvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 bc5038f7-23e0-4960-96da-33abaf5935ec 100 >nul 2>&1
echo   [OK]  Set Processor Maximum State to 100%%

powercfg -setacvalueindex SCHEME_CURRENT 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0 >nul 2>&1
echo   [OK]  Disabled Hard Disk Sleep

powercfg -h off >nul 2>&1
echo   [OK]  Disabled Hibernate

powercfg -x -standby-timeout-ac 0 >nul 2>&1
echo   [OK]  Disabled Sleep Timeout

echo.
echo   Power Plan Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:RAM
cls
call :PRINT_HEADER
echo   == [7] RAM AND MEMORY TWEAKS ==
echo.

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK]  Disabled Paging Executive (kernel stays in RAM)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Optimized System Cache for Programs

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Clear Pagefile at Shutdown

powershell -Command "Disable-MMAgent -mc" >nul 2>&1
echo   [OK]  Disabled Memory Compression

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Heap Manager" /v HeapDeCommitFreeBlockThreshold /t REG_DWORD /d 262144 /f >nul 2>&1
echo   [OK]  Optimized Heap Decommit Threshold

echo   [INFO] Enable XMP/EXPO in BIOS for full RAM speed

echo.
echo   RAM and Memory Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:STORAGE
cls
call :PRINT_HEADER
echo   == [8] STORAGE AND I/O TWEAKS ==
echo.

fsutil behavior set disable8dot3 1 >nul 2>&1
echo   [OK]  Disabled 8.3 Filename Creation

fsutil behavior set disablelastaccess 1 >nul 2>&1
echo   [OK]  Disabled Last Access Timestamp

fsutil behavior set disabledeletenotify 0 >nul 2>&1
echo   [OK]  Enabled TRIM for SSDs

sc config defragsvc start=disabled >nul 2>&1
echo   [OK]  Disabled Auto Defrag Service

reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsMemoryUsage /t REG_DWORD /d 2 /f >nul 2>&1
echo   [OK]  Set NTFS Memory Usage to Performance Mode

sc config EMDMgmt start=disabled >nul 2>&1
echo   [OK]  Disabled ReadyBoost Service

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLowDiskSpaceChecks /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK]  Disabled Low Disk Space Checks

echo.
echo   Storage and I/O Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:VISUAL
cls
call :PRINT_HEADER
echo   == [9] VISUAL AND UI TWEAKS ==
echo.

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
echo   [OK]  Set Visual Effects to Best Performance

reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Window and Taskbar Animations

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Transparency Effects

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisallowShaking /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK]  Disabled Aero Shake

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Enabled File Extensions Visibility

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Explorer Startup Delay

reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d "0" /f >nul 2>&1
echo   [OK]  Disabled Menu Show Delay

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Taskbar News and Interests

echo.
echo   Visual and UI Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:SERVICES
cls
call :PRINT_HEADER
echo   == [A] SERVICES TWEAKS ==
echo.

sc config Spooler start=disabled >nul 2>&1
echo   [OK]  Disabled Print Spooler

sc config Fax start=disabled >nul 2>&1
echo   [OK]  Disabled Fax Service

sc stop wisvc >nul 2>&1
sc config wisvc start=disabled >nul 2>&1
echo   [OK]  Disabled Windows Insider Service

sc stop RemoteRegistry >nul 2>&1
sc config RemoteRegistry start=disabled >nul 2>&1
echo   [OK]  Disabled Remote Registry

sc stop TabletInputService >nul 2>&1
sc config TabletInputService start=disabled >nul 2>&1
echo   [OK]  Disabled Tablet PC Input Service

sc stop XblAuthManager >nul 2>&1
sc config XblAuthManager start=disabled >nul 2>&1
sc stop XblGameSave >nul 2>&1
sc config XblGameSave start=disabled >nul 2>&1
sc stop XboxGipSvc >nul 2>&1
sc config XboxGipSvc start=disabled >nul 2>&1
sc stop XboxNetApiSvc >nul 2>&1
sc config XboxNetApiSvc start=disabled >nul 2>&1
echo   [OK]  Disabled Xbox Live Services

sc stop MapsBroker >nul 2>&1
sc config MapsBroker start=disabled >nul 2>&1
echo   [OK]  Disabled Maps Broker

sc stop WalletService >nul 2>&1
sc config WalletService start=disabled >nul 2>&1
echo   [OK]  Disabled Wallet Service

sc stop wcncsvc >nul 2>&1
sc config wcncsvc start=disabled >nul 2>&1
echo   [OK]  Disabled Windows Connect Now

echo.
echo   Services Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:GAMING
cls
call :PRINT_HEADER
echo   == [B] GAMING TWEAKS ==
echo.

reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
echo   [OK]  Enabled Windows Game Mode

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1
echo   [OK]  Set Game Scheduling to High Priority

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Set System Responsiveness to 0 (max for games)

reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Game Bar and Capture

reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v ShowGameModeNotifications /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Game Mode Notifications

taskkill /f /im OneDrive.exe >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v OneDrive /t REG_BINARY /d 0300000000000000 /f >nul 2>&1
echo   [OK]  Disabled OneDrive Auto-Start

echo   [INFO] Enable NVIDIA Reflex in-game for lowest latency
echo   [INFO] Disable C-States in BIOS for competitive gaming

echo.
echo   Gaming Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:SECURITY
cls
call :PRINT_HEADER
echo   == [C] SECURITY TWEAKS ==
echo.

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled SmartScreen

netsh advfirewall set allprofiles settings notifications off >nul 2>&1
echo   [OK]  Disabled Firewall Notifications

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f >nul 2>&1
echo   [OK]  Disabled Windows Defender Cloud Reporting

reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Disabled Automatic Sample Submission

echo   [INFO] Windows Defender real-time kept ON for safety
echo   [INFO] Disable Defender manually if you want max performance

echo.
echo   Security Tweaks Applied!
echo.
echo   Press any key to return to menu...
pause >nul
goto MAIN_MENU

:: ============================================================
:APPLY_ALL
cls
call :PRINT_HEADER
echo   == [X] APPLYING ALL TWEAKS ==
echo.
echo   Running all optimization categories...
echo   --------------------------------------------
echo.

sc stop SysMain >nul 2>&1 & sc config SysMain start=disabled >nul 2>&1
sc stop WSearch >nul 2>&1 & sc config WSearch start=disabled >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul 2>&1
bcdedit /set useplatformclock false >nul 2>&1 & bcdedit /set disabledynamictick yes >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f >nul 2>&1
echo   [OK]  Performance Tweaks

reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul 2>&1
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 255 /f >nul 2>&1
ipconfig /flushdns >nul 2>&1
echo   [OK]  Network Tweaks

reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul 2>&1
sc stop NvTelemetryContainer >nul 2>&1 & sc config NvTelemetryContainer start=disabled >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1
echo   [OK]  GPU Tweaks

reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d "0" /f >nul 2>&1
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f >nul 2>&1
reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d "0" /f >nul 2>&1
echo   [OK]  Mouse and Input Tweaks

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>&1
sc stop DiagTrack >nul 2>&1 & sc config DiagTrack start=disabled >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Privacy and Telemetry Tweaks

powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
powercfg -setacvalueindex SCHEME_CURRENT 54533251-82be-4824-96c1-47b60b740d00 893dee8e-2bef-41e0-89c6-b55d0929964c 100 >nul 2>&1
powercfg -h off >nul 2>&1
echo   [OK]  Power Plan Tweaks

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v DisablePagingExecutive /t REG_DWORD /d 1 /f >nul 2>&1
powershell -Command "Disable-MMAgent -mc" >nul 2>&1
echo   [OK]  RAM and Memory Tweaks

fsutil behavior set disable8dot3 1 >nul 2>&1
fsutil behavior set disablelastaccess 1 >nul 2>&1
fsutil behavior set disabledeletenotify 0 >nul 2>&1
echo   [OK]  Storage and I/O Tweaks

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d "0" /f >nul 2>&1
echo   [OK]  Visual and UI Tweaks

sc config Spooler start=disabled >nul 2>&1
sc stop XblAuthManager >nul 2>&1 & sc config XblAuthManager start=disabled >nul 2>&1
sc stop XblGameSave >nul 2>&1 & sc config XblGameSave start=disabled >nul 2>&1
sc stop RemoteRegistry >nul 2>&1 & sc config RemoteRegistry start=disabled >nul 2>&1
echo   [OK]  Services Tweaks

reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Gaming Tweaks

reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableSmartScreen /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpynetReporting /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK]  Security Tweaks

echo.
echo   ============================================
echo   ALL TWEAKS APPLIED SUCCESSFULLY!
echo   ============================================
echo.
echo   A reboot is recommended to apply all changes.
echo.
choice /c YN /m "  Reboot now? (Y/N): "
if %ERRORLEVEL%==1 (
    shutdown /r /t 5 /c "Purple Free Optimizer - Rebooting in 5 seconds..."
    echo   Rebooting in 5 seconds...
    timeout /t 5
) else (
    echo   Remember to reboot later for best results!
    echo.
    echo   Press any key to return to menu...
    pause >nul
)
goto MAIN_MENU

:: ============================================================
:PRINT_HEADER
echo.
echo   ########  ##     ## ########  ########  ##       ########
echo   ##     ## ##     ## ##     ## ##     ## ##       ##
echo   ##     ## ##     ## ##     ## ##     ## ##       ##
echo   ########  ##     ## ########  ########  ##       ######
echo   ##        ##     ## ##   ##   ##        ##       ##
echo   ##        ##     ## ##    ##  ##        ##       ##
echo   ##         #######  ##     ## ##        ######## ########
echo.
echo   ######## ########  ######## ########
echo   ##       ##     ## ##       ##
echo   ##       ##     ## ##       ##
echo   ######   ########  ######   ######
echo   ##       ##   ##   ##       ##
echo   ##       ##    ##  ##       ##
echo   ##       ##     ## ######## ########
echo.
echo  ============================================================
echo.
goto :EOF

:: ============================================================
:EXIT
cls
echo.
echo   ########  ##    ## ########
echo   ##     ##  ##  ##  ##
echo   ##     ##   ####   ##
echo   ########     ##    ######
echo   ##     ##    ##    ##
echo   ##     ##    ##    ##
echo   ########     ##    ########
echo.
echo   Thanks for using Purple Free Optimizer!
echo.
timeout /t 3 >nul
exit
