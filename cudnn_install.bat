@echo off
set DOWNLOAD_DIR=%~dp0
set CUDA_INSTALL_TARGET_DIR=C:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v%CUDA_VER%
set CURRENT_DIR=%~dp0
set TEMP_DIR_NAME=cudnn-achive-dir
CD /d %~dp0
net session >nul 2>&1
IF %ERRORLEVEL% equ 0 (
ECHO Administrator is running it.
) ELSE (
ECHO Administrator is not running it.
PAUSE
exit
)
cd %DOWNLOAD_DIR%
for /f "usebackq delims=" %%A in (`DIR /W /A *.zip ^| findstr "^cudnn-"`) do set TMP_WORD=%%A
echo %TMP_WORD%
set TMP_CUDA_DIR=%ChocolateyInstall%
call powershell -command "Expand-Archive -Path %TMP_WORD% -DestinationPath .\%TEMP_DIR_NAME%"
copy /Y "%DOWNLOAD_DIR%\%TEMP_DIR_NAME%\cuda\bin\*" "%CUDA_INSTALL_TARGET_DIR%\bin"
copy /Y "%DOWNLOAD_DIR%\%TEMP_DIR_NAME%\cuda\include\*" "%CUDA_INSTALL_TARGET_DIR%\include"
copy /Y "%DOWNLOAD_DIR%\%TEMP_DIR_NAME%\cuda\lib\x64\*" "%CUDA_INSTALL_TARGET_DIR%\lib\x64"
pause
CD %CURRENT_DIR%