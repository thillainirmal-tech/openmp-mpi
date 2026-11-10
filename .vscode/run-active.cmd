@echo off
setlocal
if /i not "%~x1"==".c" if /i not "%~x1"==".cpp" (
    echo Open a .c or .cpp file before running.
    exit /b 1
)
for %%D in ("%~dp1.") do set "mode=%%~nxD"
if /i not "%mode%"=="OpenMP" if /i not "%mode%"=="MPI" (
    echo Save your source file directly inside the OpenMP or MPI folder.
    exit /b 1
)
set "vswhere=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
if not exist "%vswhere%" goto missing_compiler
set "vcvars="
for /f "usebackq delims=" %%I in (`"%vswhere%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -find VC\Auxiliary\Build\vcvars64.bat`) do set "vcvars=%%I"
if not defined vcvars goto missing_compiler
call "%vcvars%" >nul || exit /b 1
set "build=%~dp0..\.build\%mode%"
if not exist "%build%" mkdir "%build%"
pushd "%build%" || exit /b 1
if /i "%mode%"=="MPI" goto mpi

cl /nologo /openmp /Fe:practice.exe "%~f1" || exit /b 1
popd
cd /d "%~dp1" || exit /b 1
"%build%\practice.exe"
exit /b %errorlevel%

:mpi
set "mpi_sdk=%~dp0mpi-sdk"
if not exist "%mpi_sdk%\Include\mpi.h" set "mpi_sdk=%ProgramFiles(x86)%\Microsoft SDKs\MPI"
if not exist "%mpi_sdk%\Include\mpi.h" (
    echo Microsoft MPI SDK is missing. Install msmpisdk.msi from the link in README.md.
    exit /b 1
)
set "mpi_bin=%ProgramFiles%\Microsoft MPI\Bin"
if not exist "%mpi_bin%\mpiexec.exe" (
    echo Microsoft MPI runtime is missing. Install msmpisetup.exe from the link in README.md.
    exit /b 1
)
set "ranks=4"
if exist "%~dp1process-count.txt" for /f %%N in ('findstr /r /x "[1-9][0-9]*" "%~dp1process-count.txt"') do set "ranks=%%N"

cl /nologo /I"%mpi_sdk%\Include" /I"%mpi_sdk%\Include\x64" /Fe:practice.exe "%~f1" /link /LIBPATH:"%mpi_sdk%\Lib\x64" msmpi.lib || exit /b 1
popd
cd /d "%~dp1" || exit /b 1
"%mpi_bin%\mpiexec.exe" -n "%ranks%" "%build%\practice.exe"
exit /b %errorlevel%

:missing_compiler
echo Visual Studio C++ tools are missing. Install the Desktop development with C++ workload.
exit /b 1
