#!/bin/bash

function sendToMQTT() {
	java -jar pisidWithAutomaticTests.jar "SendToMQTT"
}

sendToMQTT
