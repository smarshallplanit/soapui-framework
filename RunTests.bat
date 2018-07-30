@echo off
title Run SOAPUI test and Running ANT to create HTML!
echo converting Junit XML to HTML report
setlocal

REM cd /d %~dp0
REM cd


REM call java com.eviware.soapui.tools.SoapUITestCaseRunner -sSCENARIOS -a -j -J -r -fC:\MvnProject\TEL.tests "C:\MvnProject\TEL.tests\Basic framework-soapui-project.xml"

call "C:\Program Files\SmartBear\SoapUI-5.4.0\bin\testrunner.bat" -sSCENARIOS  -j -J -r -fC:\MvnProject\TEL.tests "C:\MvnProject\TEL.tests\Basic framework-soapui-project.xml"

:: This will create a timestamp like yyyy-mm-dd-hh-mm-ss.
set TIMESTAMP=%DATE:~10,4%-%DATE:~4,2%-%DATE:~7,2%
set TIME=%TIME:~0,2%-%TIME:~3,2%-%TIME:~6,2%
@echo TIMESTAMP=%TIMESTAMP%

:: Create a new directory\

md "%TIMESTAMP%-LOGS"


REM ren "global-groovy.txt" "%TIME%GroovyLogs"


ren "soapui.log" "SoapUiLogs-%TIME%.log"
move  SoapUiLogs-%TIME%.log  %~dp0\%TIMESTAMP%-LOGS
ren "soapui-errors.log" "ErrorLogs-%TIME%.log"
move  ErrorLogs-%TIME%.log  %~dp0\%TIMESTAMP%-LOGS"

ren "global-groovy.log" "ScriptLogs-%TIME%.log"
move  "ScriptLogs-%TIME%.log" %~dp0\%TIMESTAMP%-LOGS"



call ant

pause

