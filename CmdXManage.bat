@echo off
:: ===================================================
:: CmdXManage.bat - Custom Command Manager for CMD
:: Author: Aarush Chaudhary
:: GitHub: https://github.com/AjeyVerma
:: ===================================================


@echo off

:: Define folder under user's AppData\Local
set "folder=%LOCALAPPDATA%\CmdXManage"

:: Check if folder exists
if not exist "%folder%" (
    echo Folder "%folder%" does not exist.
    echo Creating it now...
    mkdir "%folder%"
)

echo Folder "%folder%" exists.
echo.

:: Check if already in User PATH
echo Checking if "%folder%" is already in User PATH...
reg query "HKCU\Environment" /v Path | find /I "%folder%" >nul
if %errorlevel%==0 (
    echo "%folder%" is already in User PATH. Nothing to do.
    goto mainmenu
)

:: Add to User PATH (permanent for current user)
echo Adding "%folder%" to USER PATH...
for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul ^| find "Path"') do set "UserPath=%%B"
if defined UserPath (
    setx PATH "%UserPath%;%folder%"
) else (
    setx PATH "%folder%"
)

echo.
echo ✅ Done! Restart CMD or sign out/in to see the changes.
pause

:mainmenu
cls
:header
color 1F
echo   ___  __  __  ____  _  _  __  __    __    _  _    __    ___  ____  
echo  / __)(  \/  )(  _ \( \/ )(  \/  )  /__\  ( \( )  /__\  / __)( ___)
echo ( (__  )    (  )(_) ))  (  )    (  /(__)\  )  (  /(__)\( (_-. )__) 
echo  \___)(_/\/\_)(____/(_/\_)(_/\/\_)(__)(__)(_)\_)(__)(__)\___/(____)
echo.
echo @Ajay Verma ( Aarush )
echo.
echo A CMD script to create ^& manage your custom commands in Window Command Prompt.
echo.
echo Created by Aarush Chaudhary
echo GitHub: https://github.com/AjeyVerma
echo Instagram: https://instagram.com/ajayverma097
echo LinkedIn: https://linkedin.com/in/AjeyVerma
echo.
echo #You can visit the script repo to explore more tool releated to the commands. 
echo Script Repo: https://github.com/ajeyverma/CmdXManage
echo.
echo ======================================
echo     CMDXManage - Command Manager
echo ======================================
echo [1] View Commands
echo [2] Add Command
echo [3] Edit Command
echo [4] Remove Command
echo [5] Settings
echo [6] Exit
echo ======================================
set /p choice="Enter choice: "

if "%choice%"=="1" goto view
if "%choice%"=="2" goto add
if "%choice%"=="3" goto edit
if "%choice%"=="4" goto remove
if "%choice%"=="5" goto submenu
if "%choice%"=="6" exit /b
if "%choice%"=="exit" exit /b
goto mainmenu

::-----------------------------------------------------------------------------------

:view
cls
:: Display Number of .bat files in a specific folder
set "pathToCheck=%folder%"
set count=0

if exist "%pathToCheck%\*.bat" (
    for %%f in ("%pathToCheck%\*.bat") do set /a count+=1
)

echo Found %count% commands files in %pathToCheck%
:: Display all commands
set "counter=1"
setlocal enabledelayedexpansion

if exist "%pathToCheck%\*.bat" (
    for %%f in ("%pathToCheck%\*.bat") do (
        echo !counter!. %%~nf
        set /a counter+=1
    )
) else (
    echo (No commands found.)
)

pause
goto mainmenu

::----------------------------------------------------------------------------------------

:add
cls
setlocal EnableExtensions DisableDelayedExpansion

:: Ensure folder exists
if not exist "%folder%" (
    echo Folder "%folder%" does not exist. Creating...
    mkdir "%folder%"
)

:: Ask for filename
set "filename="
set /p "filename=Enter command name: "

:: Trim spaces
for /f "tokens=* delims=" %%A in ("%filename%") do set "filename=%%A"

:: 1. Check if blank
if not defined filename (
    echo ERROR: Command cannot be blank.
    pause
    goto mainmenu
)

:: 2 & 3. Disallow starting with - or _
echo(%filename%| findstr /r /b /c:"[-_]" >nul && goto badName

:: Check filename contains only allowed chars (letters, numbers, _ or -)
echo(%filename%| findstr /r "^[A-Za-z0-9_-][A-Za-z0-9_-]*$" >nul || goto badChars

:: 4. Check if file already exists
if exist "%folder%\%filename%.bat" (
    echo ERROR: Command already present.
    pause
    goto mainmenu
)

:: Ask for command
set "usercmd="
set /p "usercmd=Enter command to run: "

:: Check if blank
if not defined usercmd (
    echo ERROR: Command to run cannot be blank.
    pause
    goto mainmenu
)

:: Build full path
set "filepath=%folder%\%filename%.bat"

:: Write the content into the .bat file
(
    echo @echo off
    echo %usercmd%
) > "%filepath%"

echo New Command added Succesfully.

pause
goto mainmenu

::-----------------------------------------------------------------------------------------

:edit
cls
if not exist "%datafile%" (
    echo No commands to edit.
    pause
    goto mainmenu
)
type "%datafile%"
set /p ename="Enter command name to edit: "
set "found="
for /f "tokens=1* delims==" %%a in ('findstr /i "^%ename%=" "%datafile%"') do (
    set found=1
    set oldcmd=%%b
)
if not defined found (
    echo Command not found!
    pause
    goto mainmenu
)
echo Old command: %oldcmd%
set /p newcmd="Enter new command: "
>temp.txt (
    for /f "usebackq tokens=1* delims==" %%a in ("%datafile%") do (
        if /i "%%a"=="%ename%" (
            echo %%a=%newcmd%
        ) else (
            echo %%a=%%b
        )
    )
)
move /y temp.txt "%datafile%" >nul
doskey %ename%=%newcmd%
echo Command updated!
pause
goto mainmenu

::------------------------------------------------------------------------------------------

:remove
cls
set "folder=%LOCALAPPDATA%\CmdXManage"
:: Display Number of .bat files in a specific folder
set "pathToCheck=%folder%"
set count=0

if exist "%pathToCheck%\*.bat" (
    for %%f in ("%pathToCheck%\*.bat") do set /a count+=1
)

echo Found %count% commands files in %pathToCheck%
:: Display all commands
set "counter=1"
setlocal enabledelayedexpansion

if exist "%pathToCheck%\*.bat" (
    for %%f in ("%pathToCheck%\*.bat") do (
        echo !counter!. %%~nf
        set /a counter+=1
    )
) else (
    echo (No commands found.)
)

echo.
:: Ask user for the file name to delete
set "filename="
set /p "filename=Enter the filename to remove: "

:: Check if the file exists
if not exist "%folder%\%filename%.bat" (
    echo ERROR: File "%filename%" does not exist.
    pause
    goto mainmenu
)

:: Delete the file
del /f /q "%folder%\%filename%.bat"
echo File "%filename%" deleted successfully.
pause
goto mainmenu

::---------------------------------------------------------------------------------------------

:export
cls
@echo off
setlocal

set "source=%LOCALAPPDATA%\CmdXManage"

:: Ask user where to save
powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; if ($f.ShowDialog() -eq 'OK') { Write-Output $f.SelectedPath }" > "%temp%\folder.txt"

set /p baseTarget=<"%temp%\folder.txt"
del "%temp%\folder.txt"

if not defined baseTarget (
    echo Export canceled.
    pause
    goto mainmenu
)

:: Create unique timestamped folder inside chosen path
set "datetime=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
set "datetime=%datetime: =0%"
set "target=%baseTarget%\CmdXManage_Export_%datetime%"

mkdir "%target%" >nul 2>&1

:: Copy all .bat files
xcopy "%source%\*.bat" "%target%\" /Y /I >nul

echo Export completed to: "%target%"
pause
goto mainmenu


:import
setlocal EnableExtensions EnableDelayedExpansion

:: Target folder
set "FOLDER=%LOCALAPPDATA%\CmdXManage"
if not exist "%FOLDER%" mkdir "%FOLDER%"

echo Select the folder to IMPORT from...

:: Folder picker via PowerShell (single-line, no carets)
powershell -NoProfile -Command "$sa=New-Object -ComObject Shell.Application; $b=$sa.BrowseForFolder(0,'Select import folder',0); if($b){[Console]::WriteLine($b.Self.Path)}" > "%temp%\__pickdir.txt"

set "SOURCE="
set /p SOURCE=<"%temp%\__pickdir.txt"
del "%temp%\__pickdir.txt" >nul 2>&1

if not defined SOURCE (
  echo No folder selected.
  pause
  exit /b 1
)

if not exist "%SOURCE%" (
  echo ERROR: Folder "%SOURCE%" does not exist.
  pause
  exit /b 1
)

:: Work inside the source folder to handle spaces safely
pushd "%SOURCE%" || (
  echo ERROR: Cannot access "%SOURCE%".
  pause
  exit /b 1
)

:: Ensure there are .bat files
dir /b *.bat >nul 2>&1 || (
  popd
  echo No .bat files found in "%SOURCE%".
  pause
  exit /b 1
)

set "newCount=0"
set "replacedCount=0"

:: Copy all .bat files; if duplicate exists, delete old first
for /f "delims=" %%F in ('dir /b *.bat') do (
  if exist "%FOLDER%\%%F" (
    del /f /q "%FOLDER%\%%F"
    set /a replacedCount+=1
  ) else (
    set /a newCount+=1
  )
  copy /y "%%F" "%FOLDER%\%%F" >nul
  echo Imported: %%F
)

popd

echo.
echo Import finished: !newCount! new file(s), !replacedCount! replaced.
pause
goto mainmenu


::---------------------------------------------------------------------------------------------
:updateScript
cls
echo Updating CmdXManage from GitHub...

:: Local script path
set "localScript=%~f0"

:: Temp file for downloaded script
set "tempScript=%temp%\CmdXManage_latest.bat"

:: Try to download from GitHub (raw link of your .bat file)
curl -s -L "https://raw.githubusercontent.com/AjeyVerma/CmdXManage/main/CmdXManage.bat" -o "%tempScript%" >nul 2>&1

:: Check if download worked
if not exist "%tempScript%" (
    echo ERROR: No internet connection or GitHub not reachable.
    pause
    goto mainmenu
)

:: Replace old script with new one
copy /y "%tempScript%" "%localScript%" >nul
del "%tempScript%"

echo Script updated successfully! Please restart.
pause
exit

::---------------------------------------------------------------------------------------------
:submenu
cls
echo ======================================
echo [1] Export Commands
echo [2] Import Commands
echo [3] Delete All Commands
echo [4] Update Script
echo [5] Exit
echo ======================================
set /p choice="Enter choice: "

if "%choice%"=="1" goto export
if "%choice%"=="2" goto import
if "%choice%"=="3" goto deleteall
if "%choice%"=="4" goto updateScript
if "%choice%"=="5" goto mainmenu
goto mainmenu
::----------------------------------------------------------------------------------------------

:deleteAll
setlocal EnableDelayedExpansion

:: Set folder
set "pathToCheck=%folder%"
set "confirm="
set /p "confirm=Are you sure you want to delete ALL these commands? (Y/N): "

if /i "%confirm%"=="Y" (
    del /q "%pathToCheck%\*.bat"
    echo All commands deleted successfully.
) else (
    echo Deletion cancelled.
)

pause
goto mainmenu


::-----------------------------------------------------------------------------------------------

:badName
echo ERROR: Command name cannot start with a hyphen (-) or underscore (_).
pause
goto mainmenu

::------------------------------------------------------------------------------------------------

:badChars
echo ERROR: Command name may only contain letters, numbers, underscores (_), or hyphens (-).
pause

goto mainmenu
