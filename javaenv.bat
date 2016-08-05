@ECHO OFF
if "%1"=="" goto empty
if "%1"=="echo" goto output
if "%1"=="e" goto output
if "%1"=="list" goto list
if "%1"=="l" goto list
if "%1"=="add" goto add
if "%1"=="a" goto add
if "%1"=="remove" goto remove
if "%1"=="r" goto remove

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

:list
  FOR /f "delims=" %%x IN (%~dp0java_versions.store) DO (
    echo "%%~x"
  )
  goto :EOF

:add
  if "%2"=="" (
    ECHO "Name of the entry missing"
    goto :EOF
  )
  if "%~3"=="" (
    ECHO "Path of the entry missing"
    goto :EOF
  )
  IF EXIST "%~3" (
    echo %2="%~3">> %~dp0java_versions.store
    ECHO %2="%~3" added
  ) ELSE (
    ECHO %3 is not an actual folder
  )
  goto :EOF

:remove
  if "%2"=="" (
    ECHO "Name of the entry missing as an argument of the batch"
    goto :EOF
  )
  set "found="
  for /f "delims== tokens=1,2" %%a in (%~dp0java_versions.store) do (
     if "%2"=="%%a" (
       set found=1
       echo found
     )
  )
  if defined found  (
    for /f "delims== tokens=1,2" %%a in (%~dp0java_versions.store) do (
      if "%2"=="%%a" (
        echo nothing
      ) ELSE (
        echo test
      )
    )
    ECHO Entry %2 deleted
  )

  goto :EOF

:empty
  ECHO "Empty argument, please provide an argument"
  goto :EOF
