@echo off

:: Define a function to launch SendToMongo
:launchSendToMongo
java -jar pisidWithAutomaticTests.jar "SendToMongo"
goto :eof
