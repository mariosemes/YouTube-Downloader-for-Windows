@ECHO off
call config\config.bat
call config\folderchecker.bat



if %audio%==true (
set codec=%audio-codec%
) else (
set codec=%video-codec%
)

if %dlselect%==option1 (
call :singledownload
set success=true
goto :eof
) else if %dlselect%==option2 (
call :multipledatafile
set success=true
goto :eof
) else if %dlselect%==option3 (
call :multiplecustomfile
set success=true
goto :eof
) else if %dlselect%==option4 (
call :multipleplaylist
set success=true
goto :eof
) else (
goto :eof
)

:singledownload
cls
echo Paste your YouTube video link (ex: https://www.youtube.com/watch?v=Bey4XXJAqS8)
set /p itemid=or type b to go back:

set completedfolder=completed

if %audioconverting%==false (
goto :singledownload-nocon
) else (
goto :singledownload-con
)

:singledownload-nocon
cls
rem Download video
exe\youtube-dl.exe -i -f %codec% %video-pref% -o "%dllocation%\completed\%%(title)s.%%(ext)s" %itemid%

goto :eof

:singledownload-con
cls
for /f "delims=*" %%a in ('exe\youtube-dl.exe --get-filename -o "%%(title)s" "%itemid%"') do set name=%%a

rem Download video
exe\youtube-dl.exe -i -f %codec% %video-pref% -o "%dllocation%\incompleted\%%(title)s.%%(ext)s" %itemid%

rem Create mp3
cls
exe\ffmpeg.exe -n -i "%dllocation%\incompleted\%name%.m4a" %audio-encode% "%dllocation%\completed\%name%.mp3"

del "%dllocation%\incompleted\*" /f /q

goto :eof



:multipledatafile

set completedfolder=completed\datalist

if %audioconverting%==false (
goto :multipledatafile-nocon
) else (
goto :multipledatafile-con
)

:multipledatafile-nocon
for /f "tokens=*" %%x in (data.txt) do call :processwithdata1 %%x
goto :eof

:processwithdata1
cls
rem Download video
exe\youtube-dl.exe -i -f %codec% %video-pref% -o "%dllocation%\completed\datalist\%%(title)s.%%(ext)s" %*

goto :eof


:multipledatafile-con
cls
for /f "tokens=*" %%x in (data.txt) do call :processwithdata2 %%x
goto :eof

:processwithdata2

for /f "delims=*" %%a in ('exe\youtube-dl.exe -i --get-filename -o "%%(title)s" "%*"') do set name=%%a

rem Download video
exe\youtube-dl.exe -i -f %codec% %video-pref% -o "%dllocation%\incompleted\%%(title)s.%%(ext)s" %*

rem Create mp3
cls
exe\ffmpeg.exe -n -i "%dllocation%\incompleted\%name%.m4a" %audio-encode% "%dllocation%\completed\datalist\%name%.mp3"

del "%dllocation%\incompleted\*" /f /q

goto :eof



:multiplecustomfile
cls
echo Drag and drop your list here
set /p datafile=or type b to go back: 

set completedfolder=completed\customlist

if %audioconverting%==false (
goto :multiplecustomfile-nocon
) else (
goto :multiplecustomfile-con
)

:multiplecustomfile-nocon
cls
for /f "tokens=*" %%x in (%datafile%) do call :processwithcustom1 %%x
goto :eof

:processwithcustom1
rem Download video
exe\youtube-dl.exe -i -f %codec% %video-pref% -o "%dllocation%\completed\customlist\%%(title)s.%%(ext)s" %*

goto :eof


:multiplecustomfile-con
cls
for /f "tokens=*" %%x in (%datafile%) do call :processwithcustom2 %%x
goto :eof

:processwithcustom2
rem Download video
exe\youtube-dl.exe -i -f %codec% %video-pref% -o "%dllocation%\incompleted\%%(title)s.%%(ext)s" %*
for /f "delims=*" %%a in ('exe\youtube-dl.exe -i --get-filename -o "%%(title)s" "%*"') do set name=%%a

rem Create mp3
cls
exe\ffmpeg.exe -n -i "%dllocation%\incompleted\%name%.m4a" %audio-encode% "%dllocation%\completed\customlist\%name%.mp3"

del "%dllocation%\incompleted\*" /f /q

goto :eof




:multipleplaylist
cls
echo Paste your Playlist ID (ex: PLFrMSo5iYMj9ZwfbpvjaWKCMbNxInp-ks)
set /p playlist=or type b to go back: 

if %audioconverting%==false (
goto :multipleplaylist-nocon
) else (
goto :multipleplaylist-con
)

:multipleplaylist-nocon
cls
rem Download video
exe\youtube-dl.exe -i -f %codec% %video-pref% -o "%dllocation%\completed\%%(playlist)s\%%(title)s.%%(ext)s" https://www.youtube.com/playlist?list=%playlist%

goto :eof


:multipleplaylist-con
cls
echo Please wait, scraping IDs...
break>playlist.txt
exe\youtube-dl.exe -i --get-id "https://www.youtube.com/playlist?list=%playlist%">playlist.txt

for /f "delims=*" %%b in ('exe\youtube-dl.exe -i --get-filename -o "%%(playlist)s" "https://www.youtube.com/playlist?list=%playlist%"') do set playlistname=%%b

for /F "tokens=*" %%x in (playlist.txt) do call :processwithlist %%x

set completedfolder=completed\%playlistname%

goto :eof

:processwithlist
rem Download video
exe\youtube-dl.exe -i -f %codec% %video-pref% -o "%dllocation%\incompleted\%%(title)s.%%(ext)s" %*

for /f "delims=*" %%a in ('exe\youtube-dl.exe -i --get-filename -o "%%(title)s" "%*"') do set name=%%a

if not exist "%dllocation%\completed\%playlistname%" (
	mkdir "%dllocation%\completed\%playlistname%"
	echo %playlistname% folder created.
) else (
	echo %playlistname% folder exists.
)

rem Create mp3
cls
exe\ffmpeg.exe -n -i "%dllocation%\incompleted\%name%.m4a" %audio-encode% "%dllocation%\completed\%playlistname%\%name%.mp3"

del "%dllocation%\incompleted\*" /f /q

set completedfolder=completed\%playlistname%

goto :eof