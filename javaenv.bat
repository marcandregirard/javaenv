@ECHO OFF
SET java_version=%1
SET JAVA6="C:\Program Files\Java\jdk1.6.0_43"
SET JAVA7="C:\Program Files\Java\jdk1.7.0_79"
SET JAVA8="C:\Program Files\Java\jdk1.8.0_73"

call :unquote JAVA_HOME %java_version%

goto :EOF

:unquote
  set %1=%~2
  goto :output
 
:output
  ECHO "JAVA_HOME=%JAVA_HOME%"
  goto :EOF
