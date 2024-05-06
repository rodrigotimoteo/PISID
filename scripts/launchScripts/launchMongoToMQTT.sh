#!/bin/bash

function sendToMQTT() {
	java -jar pisid.jar "SendToMQTT"
}

sendToMQTT
