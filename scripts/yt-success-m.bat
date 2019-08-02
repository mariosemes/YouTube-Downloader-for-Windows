@ECHO off
call config\config.bat

color 02
type dialog\success.txt
set "file=audio\success.wav"
( echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL = "%file%"
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) >sound.vbs
start /min sound.vbs
%SystemRoot%\explorer.exe "%dllocation%\%completedfolder%"
TIMEOUT /T 3
