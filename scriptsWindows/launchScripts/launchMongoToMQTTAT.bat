@echo off

:: Define a function to send to MQTT
:sendToMQTT
java -jar pisidWithAutomaticTests.jar "SendToMQTT"
goto :eof
