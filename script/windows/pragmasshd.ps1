param (
    [switch]$AutoStart = $false
)

Write-Host "AutoStart: $AutoStart"
$is_64bit = [IntPtr]::size -eq 8

# setup pragma ssh server
$down_url = "http://www.pragmasys.com/downloads/Fortress_x86.exe"
if ($is_64bit) {
    $down_url = "http://www.pragmasys.com/downloads/Fortress_x64.exe"
}

Write-Host "Downloading $down_url"
(New-Object System.Net.WebClient).DownloadFile($down_url, "C:\Windows\Temp\FortressSSH.exe")
Start-Process "C:\Windows\Temp\FortressSSH.exe" "/S /V/passive" -NoNewWindow -Wait

Stop-Service "Pragma InetD" -Force

# set vagrant pubkey
Write-Host "Configuring vagrant"
$public_key = "https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub"
(New-Object System.Net.WebClient).DownloadFile($public_key, $env:APPDATA + "\PragmaSSH\authorized_keys2")

# configure firewall
Write-Host "Configuring firewall"
netsh advfirewall firewall add rule name="SSHD" dir=in action=allow service="Pragma InetD" enable=yes
netsh advfirewall firewall add rule name="SSHD" dir=in action=allow program="C:\Program Files\Pragma\Fortress\sshd64.exe" enable=yes
netsh advfirewall firewall add rule name="ssh" dir=in action=allow protocol=TCP localport=22

Start-Service "Pragma InetD"

if ($AutoStart -eq $true) {
    Start-Service "Pragma InetD"
}
