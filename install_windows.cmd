@echo off
SETLOCAL

:: Set Local variables
set PROJ_NAME=MerciEngine
set GIT_REPO=https://github.com/sshedbalkar/MerciEngine.git
set VCPKG_DIR=vcpkg
set VCPKG_REPO=https://github.com/microsoft/vcpkg
set PROJ_DBG_DIR=build\debug

if not exist .\%VCPKG_DIR% (
    echo Installing vcpkg
    Call :INSTALL_VCPKG
    IF %ERRORLEVEL% NEQ 0 (
        echo vcpkg installation failed
        goto end
    )
)

if exist .\%PROJ_NAME% (
    echo Removing old %PROJ_NAME%
    rmdir /S /Q .\%PROJ_NAME%
)

echo Checking out %PROJ_NAME%
Call :CHECKOUT_PROJ
IF %ERRORLEVEL% NEQ 0 (
    echo %PROJ_NAME% checkout failed
    goto end
)

echo Installing dependencies
Call :INSTALL_DEPENDENCIES
IF %ERRORLEVEL% NEQ 0 (
    echo Failed to install dependencies
    goto end
)

rem Check if cmake is installed
WHERE cmake
IF %ERRORLEVEL% NEQ 0 echo cmake wasn't found, please install cmake-3.18.4-win64-x64

rem check if make is installed
WHERE make
IF %ERRORLEVEL% NEQ 0 echo make wasn't found, please install MinGW from http://www.mingw.org/

rem cd .\%PROJ_NAME%\%PROJ_DBG_DIR%\
rem cmake ..\..
rem make
echo ****************************************************************
echo *     PROJECT %PROJ_NAME% SUCCESSFULLY INSTALLED!              *
echo ****************************************************************
:end
ENDLOCAL
EXIT /B %ERRORLEVEL%

rem Checkout and install dependencies through vcpkg
:INSTALL_VCPKG
mkdir %VCPKG_DIR%
cd %VCPKG_DIR%
git clone %VCPKG_REPO% .
.\bootstrap-vcpkg.bat -disableMetrics

rem Check if vcpkg was successfully installed
if not exist .\%VCPKG_DIR%\vcpkg.exe (
    echo VCPKG installation failed!
    EXIT /B 1
)
EXIT /B 0

rem Checkout the project repository
:CHECKOUT_PROJ
mkdir %PROJ_NAME%
cd %PROJ_NAME%
git clone %GIT_REPO% .

IF %ERRORLEVEL% NEQ 0 (
    EXIT /B %ERRORLEVEL%
)

rem Save the vcpkg root folder path in project directory in a file
if not exist .\%PROJ_NAME%\.vcpkgroot (
    echo %~dp0%VCPKG_DIR%>%PROJ_NAME%\.vcpkgroot
)
EXIT /B 0

rem Install the project dependencies
:INSTALL_DEPENDENCIES
for /f "tokens=*" %%s in (.\%PROJ_NAME%\dependencies.txt) do (
    echo Installing module: %%s
    .\%VCPKG_DIR%\vcpkg install %%s:x64-windows
)
EXIT /B 0