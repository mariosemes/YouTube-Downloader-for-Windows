@ECHO off

call config\config.bat

set dlselect=0

:selection
set dlselect=0
set audio=""
cls
color 07
type dialog\welcome.txt
echo ====================================================
echo Please select your action: 
echo -
echo 1) Download Video files
echo 2) Download Audio files
echo -
echo 3) Update tools
echo ====================================================
echo.
set /p sel=Enter selection: 
if "%sel%"=="1" (
  set audio=false
  set welcomemsg=video
  goto :begin
) else (
  echo wrong selection
)
if "%sel%"=="2" (
  set audio=true
  set welcomemsg=audio
  goto :begin
) else (
  echo wrong selection
)
if "%sel%"=="3" goto :sel3

:begin
cls
color 07
type dialog\%welcomemsg%.txt
echo ====================================================
echo Please select your action: 
echo -
echo 1) Download single file
echo 2) Download multiple files using data.txt
echo 3) Download multiple files using a custom .txt
echo 4) Download a whole YouTube Playlist
echo -
echo 5) Go back to selection
echo ====================================================
echo.
set /p op=Enter selection: 

if "%op%"=="1" or "2" or "3" or "4" (
  set dlselect=option%op%
  call scripts\downloader.bat
  cls
  if %success%==false (
    goto begin
  ) else (
    call scripts\yt-success-m.bat
    goto selection
  )

) else if "%op%"=="5" (
  call scripts\update.bat
  cls
  goto begin
  ) else (
    echo Wrong selection
    TIMEOUT 3
    goto begin
  )
)

:exit
@exit