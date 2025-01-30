# Original author : Malnutrition / https://pchelpforum.net/resources/windows-11-services-safe-to-disable-for-gaming.254/
# Modified version by Takeshi Imbert

# Elevate privileges if not already running as administrator
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
  $arguments = "& '" + $myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Exit
}

# 1. Disable safe services in Windows 11
$servicesToDisable = @(
      "AppVClient",
      "BDESVC",
      "Browser",
      "DeviceAssociationService",
      "DialogBlockingService",
      "DiagTrack",
      "dmwappushservice",
      "DmEnrollmentSvc",
      "EntAppSvc",
      "Fax",
      "HgClientService",
      "HvHost",
      "InventorySvc",
      "lfsvc",
      "MapsBroker",
      "NetTcpPortSharing",
      "NgcCtnrSvc",
      "NgcSvc",
      "OneDrive Updater Service",
      "p2psvc",
      "PhoneSvc",
      "PNRPsvc",
      "PrintNotify",
      "QWAVE",
      "RasAuto",
      "RasMan",
      "RemoteRegistry",
      "RetailDemo",
      "ssh-agent",
      "SstpSvc",
      "TabletInputService",
      "vmicguestinterface",
      "vmicheartbeat",
      "vmickvpexchange",
      "vmicrdv",
      "vmicshutdown",
      "vmictimesync",
      "vmicvmsession",
      "vmicvss",
      "WalletService",
      "WerSvc",
      "WpcMonSvc",
      "XblAuthManager",
      "XblGameSave",
      "XboxNetApiSvc",
      "AdobeARMservice",
      "BITS",
      "DoSvc",
      "edgeupdate",
      "edgeupdatem",
      "gupdate",
      "gupdatem",
      "HomeGroupListener",
      "HomeGroupProvider",
      "MicrosoftEdgeUpdateService",
      "PcaSvc",
      "SharedAccess",
      "SysMain",
      "TrkWks",
      "UsoSvc",
      "WerSvc",
      "Windows Media Player Network Sharing Service",
      "WMPNetworkSvc",
      "WSearch"
    
)

foreach ($service in $servicesToDisable) {
    $serviceObj = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($serviceObj) {
        Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        Set-Service -Name $service -StartupType Disabled
        Write-Host "Disabled service: $service"
    } else {
        Write-Host "Service not found: $service"
    }
}

# 2. Clean all temp files
$tempFolders = @(
    "C:\Windows\Temp\*",
    "$env:TEMP\*"
)

foreach ($folder in $tempFolders) {
    Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "Cleaned temp files in: $folder"
}

# 3. Disable fast boot
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power"
$name = "HiberbootEnabled"
Set-ItemProperty -Path $path -Name $name -Value 0
Write-Host "Disabled fast boot"


Write-Host "Script execution completed."
