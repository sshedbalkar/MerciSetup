@echo off
SETLOCAL

:: Set Local variables
set PROJ_NAME=MerciEngine
set GIT_REPO=https://github.com/sshedbalkar/MerciEngine.git
set VCPKG_DIR=vcpkg
set VCPKG_REPO=https://github.com/microsoft/vcpkg
set PROJ_DBG_DIR=build\debug

:: Checkout and install vcpkg
::mkdir %VCPKG_DIR%
::cd %VCPKG_DIR%
::git clone %VCPKG_REPO% .
::.\bootstrap-vcpkg.bat -disableMetrics

:: Check if vcpkg was successfully installed
if not exist .\%VCPKG_DIR%\vcpkg.exe (
	echo VCPKG installation failed!
	goto end
)

:: Checkout the project repository
::mkdir %PROJ_NAME%
::cd %PROJ_NAME%
::git clone %GIT_REPO% .

:: Install the project dependencies
for /f "tokens=*" %%s in (.\%PROJ_NAME%\dependencies.txt) do (
	echo Installing module: %%s
)

::.\%VCPKG_DIR%\vcpkg install %%s:x64-windows


:: Save the vcpkg root folder path in project directory in a file
if not exist %PROJ_NAME%\.vcpkgroot (
	echo %~dp0%VCPKG_DIR%>%PROJ_NAME%\.vcpkgroot
)

:: Check if cmake is installed
WHERE cmake
IF %ERRORLEVEL% NEQ 0 echo cmake wasn't found, please install cmake-3.18.4-win64-x64

:: check if make is installed
WHERE make
IF %ERRORLEVEL% NEQ 0 echo make wasn't found, please install MinGW from http://www.mingw.org/

cd .\%PROJ_NAME%\%PROJ_DBG_DIR%\
cmake ..\..
make

:end
ENDLOCAL