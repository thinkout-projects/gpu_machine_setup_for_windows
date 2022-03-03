@echo off
CD /d %~dp0
net session >nul 2>&1
IF %ERRORLEVEL% equ 0 (
ECHO Administrator is running it.
) ELSE (
ECHO Administrator is not running it.
PAUSE
exit
)
REM chocolatey install
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
choco upgrade chocolatey -y
choco install choco.config -y
SET CONDA="%HOMEDRIVE%\tools\miniconda3\condabin\conda"
SET PIP="%HOMEDRIVE%\tools\miniconda3\Scripts\pip.exe"
ECHO miniconda settings.
%CONDA% install -y python==3.8.12 pip
REM -------- conda env --------
REM %CONDA% create -y -n tensor python==3.8.12
REM %CONDA% activate tensor
REM ---------------------------
%PIP% install -r requirements.txt
ECHO SUCCESS!
ECHO Please install cudnn!
ECHO https://developer.nvidia.com/rdp/cudnn-archive
REM https://developer.nvidia.com/compute/machine-learning/cudnn/secure/8.1.1.33/11.2_20210301/cudnn-11.2-windows-x64-v8.1.1.33.zip

SETX /m CUDA_ROOT "%PROGRAMFILES%\NVIDIA GPU Computing Toolkit\CUDA\\"
SETX /m CUDA_VER "11.2"
SETX /m CUDA_VER_PATH_NAME "11_2"
SET TMP_COMMAND=SETX /m CUDA_PATH_V%CUDA_VER_PATH_NAME% "%%CUDA_ROOT%%%CUDA_VER_PATH_NAME%"
%TMP_COMMAND%
SET TMP_COMMAND=SETX /m CUDA_PATH "%%CUDA_ROOT%%%%CUDA_VER_PATH_NAME%%"
%TMP_COMMAND%

SETX MINICONDA_PATH /M "%HOMEDRIVE%\tools\miniconda3;%HOMEDRIVE%\tools\miniconda3\Library\bin;%HOMEDRIVE%\tools\miniconda3\Scripts;%HOMEDRIVE%\tools\miniconda3\condabin;"
SET "TEMP_LEN_STR=__MINICONDA_PATH__%PATH%"
SET TEMP_LEN=0
REM IF内では環境変数の設定がうまくいかない。
for /f "usebackq" %%A in (`ECHO ";%PATH%;" ^| FIND /C /I ";%%MINICONDA_PATH%%;"`) do SET TMP_COUNT=%%A
:LOOP
if not "%TEMP_LEN_STR%"=="" (
SET "TEMP_LEN_STR=%TEMP_LEN_STR:~1%"
SET /a TEMP_LEN=%TEMP_LEN%+1
goto :LOOP
)
IF %TEMP_LEN% lss 1025 (
IF %TMP_COUNT% equ 0 (
SETX PATH /M "%%MINICONDA_PATH%%;%PATH%"
)
) ELSE (
ECHO "---- 'PATH' environment variable exceeds 1024 characters ----"
)
PAUSE