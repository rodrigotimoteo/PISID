@echo off

:: Define a function to launch SendToSQL
:launchSendToSQL
java -jar pisidWithAutomaticTests.jar "SendToSQL"
goto :eof
