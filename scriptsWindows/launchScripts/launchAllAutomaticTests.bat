@echo off

:: Define a function to start all
:startAll
java -jar pisidWithAutomaticTests.jar "ALL"
goto :eof