@echo off
setlocal enabledelayedexpansion

:: Check if more than one argument is passed
if not "%2"=="" (
    echo ERROR: Only one argument is allowed.
    exit /b
)

:: Checks if the user provided a filename
if "%1"=="" (
    set /p fileName=Enter the name of the file you wish to create a backup of: 
) else (
    set fileName=%1
)

:: Checks if the file exists
if exist "%fileName%" (
    
    :: Creates a .bak file
    copy "%fileName%" "%fileName%.bak"

    :: Ensures the backup_log.txt exists
    if not exist backup_log.txt (
        type null > backup_log.txt
        echo File created 
    )

    :: Logs the backup entry
    echo Backup of "%fileName%" created on %date% at %time% >> backup_log.txt

    :: Counts the number of lines 
    for /f "tokens=2 delims=:" %%A in (' find /c /v "" backup_log.txt') do set lineCount=%%A

    :: Check if the line count exceeds 5
    if !lineCount! gtr 5 (
        :: reads from the second line and updates backup_log.txt without the oldest entry 
        more +1 backup_log.txt > temp_log.txt
        move /y temp_log.txt backup_log.txt
        echo Oldest backup log entry deleted.
    )

) else (
    echo ERROR: "%fileName%" does not exist.
)

pause