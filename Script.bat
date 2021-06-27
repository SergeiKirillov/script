rem set mypath = %cd%\compinfo.ps1 
rem echo %mypath%
powershell.exe -noprofile -executionpolicy bypass -file %cd%\compinfo.ps1
pause 0
