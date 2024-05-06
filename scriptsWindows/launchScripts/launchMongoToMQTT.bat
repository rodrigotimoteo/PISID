@echo off

:: Define a function to send to MQTT
:sendToMQTT
java -jar pisid.jar "SendToMQTT"
goto :eof
