echo off

if not exist "%dllocation%\completed" (
	mkdir "%dllocation%\completed"
	echo completed folder created.
) else (
	echo completed folder exists.
)

if not exist "%dllocation%\incompleted" (
	mkdir "%dllocation%\incompleted"
	echo incompleted folder created.
) else (
	echo incompleted folder exists.
)

if not exist "%dllocation%\completed\datalist" (
	mkdir "%dllocation%\completed\datalist"
	echo datalist folder created.
) else (
	echo datalist folder exists.
)

if not exist "%dllocation%\completed\customlist" (
	mkdir "%dllocation%\completed\customlist"
	echo customlist folder created.
) else (
	echo customlist folder exists.
)

goto :eof


