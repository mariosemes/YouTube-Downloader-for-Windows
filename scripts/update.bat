@ECHO off
call config\config.bat

cls
echo Updating YouTube-dl. Please wait.
exe\youtube-dl.exe -U
TIMEOUT 5
exe\youtube-dl.exe --version
TIMEOUT 3
set success=true
goto :eof