#TODO https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree
#FIXMEсделать обработку и запуск функций и процедур в зависимости от версии ОС

function frmAskComment
{
    #--------------------------------------------------------------------------------------------------------------------------------------------------
    #-----------------------------Окно для ввода коментариев

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Форма для ввода коментариев'
    $form.Size = New-Object System.Drawing.Size(600,160)
    $form.StartPosition = 'CenterScreen'

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(55,80)
    $okButton.Size = New-Object System.Drawing.Size(75,23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(450,80)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(550,20)
    $label.Text = 'Введите коментарий длинной не более 100 символов(до конца строки):'
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(560,20)
    $form.Controls.Add($textBox)

    $form.Topmost = $true

    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $x = $textBox.Text
        #$x
    }
    return $x
   
}

function frmAskSaveBD
{
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Вопрос...'
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'

    $btnYes = New-Object System.Windows.Forms.Button
    $btnYes.Location = New-Object System.Drawing.Point(75,120)
    $btnYes.Size = New-Object System.Drawing.Size(75,23)
    $btnYes.Text = 'Да.'
    $btnYes.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $btnYes
    $form.Controls.Add($btnYes)

    $btnNo = New-Object System.Windows.Forms.Button
    $btnNo.Location = New-Object System.Drawing.Point(150,120)
    $btnNo.Size = New-Object System.Drawing.Size(75,23)
    $btnNo.Text = 'Нет.'
    $btnNo.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $btnNo
    $form.Controls.Add($btnNo)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Вы хотите сохранять отчет в БД:'
    $form.Controls.Add($label)


    $form.Topmost = $true

    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        SaveBD
    }
}

function SaveBD
{
    try
    {
        #---------------------------------------------------------------------------------------------------------------------------------------------------------
        # $server = "192.168.0.46"
        #echo("Адресс сервера $idAdressServer")
        $server = $idAdressServer
        $database = "AdminBD"
        $sql = "INSERT INTO SerialNumberComp (computer,Domain,userName,serialNumber,ModelNameComp,MonitorName,ipAdress,PrintName,PrintSN,OScaption,OSversion,OSbuild,OSdataInstall,OSupdate,Comment) VALUES ('"+$CompName+"', '"+$Domain+"', '"+$UserName+"', '"+$sn+"', '"+$modelName+"', '"+$MonitorName+"', '"+$IPAddress+"', '"+$PrintModel+"', '"+$PrintSN + "', '"+$OSCaption+ "', '"+$OSversion+ "', '"+$OSBuilder+ "', '"+$OSInstallData+"', '"+$OSupdate+"', '"+$Comment+"')"
        #$sql
        $SqlConnection = New-Object System.Data.SqlClient.SqlConnection
        $SqlConnection.ConnectionString = "Server=$server;Database=$database;User ID=compinfo;Password=vfhn-2021"
        $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
        $SqlCmd.CommandText = $sql
        $SqlCmd.Connection = $SqlConnection
        $SqlConnection.Open()
        $rowsAffected = $SqlCmd.ExecuteNonQuery()
        $SqlConnection.Close()
    }
    catch
    {
        Write-Host "Запись в БД с ошибкой"   
        $wshell = New-Object -ComObject Wscript.Shell
        $Output = $wshell.Popup("Запись в БД с ошибкой",5,"Скрипт по сбору информации для инвентаризации компьютеров",0) 
    }
}

function frmAskPhoto
{
    $msgBoxInput =  [System.Windows.Forms.MessageBox]::Show('Вы хотите просматривать фото в старом просмоторщике.','PhotoView','YesNoCancel')
    switch  ($msgBoxInput) {

      'Yes' {
            TweakPhoto 
            }

      'No' {
            ## Do something
            }

      'Cancel' {
            ## Do something
            }

     }
}

function TweakPhoto
{
    If  ( -Not ( Test-Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll")){New-Item -Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll" -ItemType RegistryKey -Force}
    If  ( -Not ( Test-Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell")){New-Item -Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell" -ItemType RegistryKey -Force}
    If  ( -Not ( Test-Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open")){New-Item -Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open" -ItemType RegistryKey -Force}
    Set-ItemProperty -path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open" -Name "MuiVerb" -Type "String" -Value "@photoviewer.dll,-3043"
    If  ( -Not ( Test-Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\command")){New-Item -Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\command" -ItemType RegistryKey -Force}
    Set-ItemProperty -path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\command" -Name "(Default)" -Type "ExpandString" -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
    If  ( -Not ( Test-Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\DropTarget")){New-Item -Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\DropTarget" -ItemType RegistryKey -Force}
    Set-ItemProperty -path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\open\DropTarget" -Name "Clsid" -Type "String" -Value "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"
    If  ( -Not ( Test-Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print")){New-Item -Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print" -ItemType RegistryKey -Force}
    If  ( -Not ( Test-Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\command")){New-Item -Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\command" -ItemType RegistryKey -Force}
    Set-ItemProperty -path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\command" -Name "(Default)" -Type "ExpandString" -Value "%SystemRoot%\System32\rundll32.exe `"%ProgramFiles%\Windows Photo Viewer\PhotoViewer.dll`", ImageView_Fullscreen %1"
    If  ( -Not ( Test-Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\DropTarget")){New-Item -Path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\DropTarget" -ItemType RegistryKey -Force}
    Set-ItemProperty -path "Registry::HKEY_CLASSES_ROOT\Applications\photoviewer.dll\shell\print\DropTarget" -Name "Clsid" -Type "String" -Value "{60fd46de-f830-4894-a628-6fa81bc0190d}"
    #
}


$SNComp = Get-WmiObject win32_bios
$sn = $SNComp.SerialNumber


$Domain = $env:USERDOMAIN
$CompName = $env:COMPUTERNAME
$UserName = $env:USERNAME

if ($Domain -eq "EUROPE")
{$idAdressServer = "10.21.168.42"}
else
{$idAdressServer = "192.168.0.46"}

'SerialNumber - ' + $sn
'Domain - ' + $Domain
"CompName - " + $CompName
"UserName - " + $UserName

$modelName = (Get-WmiObject Win32_ComputerSystem).Model
'Computer Model - ' + $modelName	 

#---------------------Monitor--------------------------------------------     
Try
{     
    function Decode 
    {
        If ($args[0] -is [System.Array]) 
        {
            [System.Text.Encoding]::ASCII.GetString($args[0])
        }
        Else 
        {
            "Not Found"
        }
    }

    $monitors = Get-WmiObject WmiMonitorID -Namespace root\wmi 
    $MonitorName = " "
    foreach($mon in $monitors)
    {
        $MN = (Decode $mon.UserFriendlyName -notmatch 0).Trim()
        $MSN = (Decode $mon.SerialNumberID -notmatch 0).Trim()
        $MonitorName+= $MN + "-" + $MSN + "-|-"
    }    
    
    $MonitorName = $MonitorName -replace "\s", ""
    "Мониторы -> " + $MonitorName
    
    #$Name1 = Decode (Get-WmiObject WmiMonitorID -Namespace root\wmi)[0].UserFriendlyName -notmatch 0
    #$Serial1 = Decode (Get-WmiObject WmiMonitorID -Namespace root\wmi)[0].SerialNumberID -notmatch 0
    #$Name2 = Decode (Get-WmiObject WmiMonitorID -Namespace root\wmi)[1].UserFriendlyName -notmatch 0
    #$Serial2 = Decode (Get-WmiObject WmiMonitorID -Namespace root\wmi)[1].SerialNumberID -notmatch 0
    #echo("$Name1 - $Serial1")     
    #echo("$Name2 - $Serial2")    
    
}
catch
{
    echo("Нет такой функции WMI")
}

 
 #$ipV4 = $ipaddress = $(ipconfig | where {$_ -match 'IPv4.+\s(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' } | out-null; $Matches[1])
 #$ipV4

#$IPAddress=""
#$IPAddressArr = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName .)[0].IPAddress
#Foreach($ip in $IPAddressArr)
#{
#    $IPAddress = $IPAddress+ $ip
#}
$ipc = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = True"
$IPS=""
foreach($ip in $ipc) { $IPS+=$ip.IPAddress+" " }
if ($IPS.Length -gt 30) { $IPAddress = $IPS.Remove(30)} else {$IPAddress = $IPS}
"IP adress - " + $IPAddress



$PrintModel=""
$PrintSN = "" 

#----OS vrsion--------------------
$OSversion = (Get-WmiObject Win32_OperatingSystem).version
$OSBuilder = (Get-WmiObject Win32_OperatingSystem).BuildNumber
$OSCaption = (Get-WmiObject Win32_OperatingSystem).Caption
#$OSInstallData = (Get-WmiObject Win32_OperatingSystem).InstallDate
$OSStatus = (Get-WmiObject Win32_OperatingSystem).Status
$InstallDate = Get-WmiObject -class Win32_OperatingSystem -Property InstallDate
$OSInstallData = $InstallDate.ConvertToDateTime($InstallDate.InstallDate) 



"OS версия - "+$OSversion
"OS номер сборки - "+$OSBuilder
"OS название - "+$OSCaption
"OS дата установки - "+$OSInstallData
"OS status - "+$OSStatus


$Session = New-Object -ComObject Microsoft.Update.Session
$Searcher = $Session.CreateUpdateSearcher()
$HistoryCount = $Searcher.GetTotalHistoryCount()
$OSupdate = $Searcher.QueryHistory(1,$HistoryCount)|Select-Object -First 2
#$OSupdate.GetType()

[string]$up = ""

foreach ($element in $OSupdate) {
  #$up = $up + $element.Date.Day+"."+$element.Date.Month+"."+$element.Date.Year
  #$up=$up + "  "+ $element.Date.Day.ToString()+"."+$element.Date.Month.ToString()+"."+$element.Date.Year.ToString()
  
  $up=$up + $element.Date.ToString()+ " | "
  
}

$OSupdate=$up
"Даты установки последних обновлений: " + $OSupdate


 $Comment = frmAskComment
 echo("Коментарий - $Comment")

    
#-----------------------------------------------------------------------------------------------------------------------------------------------------    
$OutArray = @()

$myobj = "" | Select "datatimeComp", "computer", "domain","IP","userName", "CompSN", "CompModel", "MonitorName", "PrintModel", "PrintSN","OSversion","OSBuilder","OSCaption","OSInstallData","OSStatus","OSupdate","Comment"
$myobj.datatimeComp = Get-Date
$myobj.computer = $CompName
$myobj.domain = $Domain
$myobj.IP = $IPAddress
$myobj.userName = $UserName
$myobj.CompSN = $sn
$myobj.CompModel = $modelName

#$myobj.MonitorName1=$Name1
#$myobj.MonitorSN1=$Serial1
#$myobj.MonitorName2=$Name2
#$myobj.MonitorSN2=$Serial2

$myobj.MonitorName=$MonitorName

$myobj.PrintModel=$PrintModel
$myobj.PrintSN=$PrintSN

$myobj.OSversion = $OSversion
$myobj.OSBuilder=$OSBuilder
$myobj.OSCaption=$OSCaption
$myobj.OSInstallData=$OSInstallData
$myobj.OSStatus=$OSStatus

$myobj.OSupdate=$OSupdate

$myobj.Comment = $Comment

$OutArray+=$myobj
$NameFile = ($MyInvocation.MyCommand.Path | Split-Path -Parent) +"\"+ $CompName+".csv"
$NameFile

$OutArray | export-csv $NameFile -Delimiter ';'

frmAskSaveBD

frmAskPhoto


