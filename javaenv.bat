@ECHO OFF
if "%1"=="" goto empty
if "%1"=="echo" goto output
if "%1"=="e" goto output
SET java_version=%1
FOR /f "delims=" %%x IN (%~dp0java_versions.store) DO (set "%%~x")
call :unquote JAVA_HOME %java_version%

goto :EOF

:unquote
  set %1=%~2
  goto :output

:output
  ECHO "JAVA_HOME=%JAVA_HOME%"
  goto :EOF

:empty
  ECHO "Empty argument, please provide an argument"
  goto :EOF
