@ECHO OFF
if "%1"=="" goto empty
if "%1"=="echo" goto output
if "%1"=="e" goto output
rem To escape '%' the sequence is '%%', so to not have to have an arg like %JAVA6%, the following will add % % on both end of the argument
SET java_version=%%%1%%

for /f "delims== tokens=1,2" %%a in (%~dp0java_versions.store) do (
   set "%%~a=%%b"
)
call :unquote JAVA_HOME %java_version%

for /f "delims== tokens=1,2" %%a in (%~dp0java_versions.store) do (
  set "%%a="
)

goto :EOF

:unquote
  set %1=%~2
  goto :output

:output
  ECHO "JAVA_HOME=%JAVA_HOME%"
  SET "java_version="
  goto :EOF

:empty
  ECHO "Empty argument, please provide an argument"
  goto :EOF
