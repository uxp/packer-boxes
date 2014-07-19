@if not defined PACKER_DEBUG echo off

setlocal EnableDelayedExpansion EnableExtensions

:: If TEMP is not defined in this shell instance, define it ourselves
if not defined TEMP set TEMP=%USERPROFILE%\AppData\Local\Temp

if exist "%SystemDrive%\Program Files (x86)" (
  set SEVENZIP_INSTALL=7z922-x64.msi
  set VMWARE_INSTALL=setup64.exe
) else (
  set SEVENZIP_INSTALL=7z922.msi
  set VMWARE_INSTALL=setup.exe
)

set SEVENZIP_URL=http://downloads.sourceforge.net/sevenzip/%SEVENZIP_INSTALL%
set SEVENZIP_INSTALL_LOCAL_DIR=%TEMP%\7zip
set SEVENZIP_INSTALL_LOCAL_PATH=%SEVENZIP_INSTALL_LOCAL_DIR%\%SEVENZIP_INSTALL%

mkdir "%SEVENZIP_INSTALL_LOCAL_DIR%"

echo ==^> Downloadling %SEVENZIP_URL% to %SEVENZIP_INSTALL_LOCAL_PATH%
PATH=%PATH%;a:\
for %%i in (_download.cmd) do set _download=%%~$PATH:i
if defined _download (
  call "%_download%" "%SEVENZIP_URL%" "%SEVENZIP_INSTALL_LOCAL_PATH%"
) else (
  powershell -Command "(New-Object System.Net.WebClient).DownloadFile('%SEVENZIP_URL%', '%SEVENZIP_INSTALL_LOCAL_PATH%')" <NUL
)
echo ==^> Download complete
echo ==^> Installing 7zip from "%SEVENZIP_INSTALL_LOCAL_PATH%"
msiexec /qb /i "%SEVENZIP_INSTALL_LOCAL_PATH%"

echo ==^> Extracting the VMWare Tools installer
"%SystemDrive%\Program Files\7-Zip\7z.exe" x -o"%TEMP%\vmware" "%USERPROFILE%\windows.iso" "%VMWARE_INSTALL%"

echo ==^> Installing VMware tools
"%TEMP%\vmware\%VMWARE_INSTALL%" /S /v "/qn REBOOT=R ADDLOCAL=ALL"

echo ==^> Cleaning up VMware tools install
del /F /S /Q "%TEMP%\vmware"

echo ==^> Removing "%USERPROFILE%\windows.iso"
del /F "%USERPROFILE%\windows.iso"

exit 0
