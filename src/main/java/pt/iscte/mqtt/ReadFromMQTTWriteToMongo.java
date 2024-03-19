
package pt.iscte.mqtt;

import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.util.JSON;
import com.mongodb.util.JSONParseException;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttMessage;
import pt.iscte.CommonUtilities;

import javax.swing.*;

/**
 * Implements the MqttCallback interface to handle MQTT message events and writes the received data to MongoDB.
 */
public class ReadFromMQTTWriteToMongo implements MqttCallback {

    /**
     * Static instances of MQTT clients for temperature and maze sensors.
     */
    MqttClient mqttClientTemp;
    MqttClient mqttClientMaze;

    /**
     * Static collections for storing sensor data in MongoDB.
     */
    static DBCollection tempSensor1;
    static DBCollection tempSensor2;
    static DBCollection doorSensor;

    /**
     * JTextArea for displaying document labels.
     */
    static JTextArea documentLabel = new JTextArea("\n");

    public static void main(String[] args) {
        documentLabel = CommonUtilities.createWindow("Cloud to Mongo");

        new ReadFromMQTTWriteToMongo().connectMongo();
        new ReadFromMQTTWriteToMongo().connectCloud();
    }

    /**
     * Connects to the MQTT broker using the configuration from the Configuration.ini file.
     *
     * @throws RuntimeException if an error occurs during connection to the MQTT broker
     */
    public void connectCloud() {
        MqttClient[] mqttClients = CommonUtilities.connectCloud(this, "MQTTCloud");

        mqttClientTemp = mqttClients[0];
        mqttClientMaze = mqttClients[1];
    }

    /**
     * Connects to the MongoDB server and initializes database collections.
     */
    public void connectMongo() {
        DBCollection[] dbCollections = CommonUtilities.connectMongo();

        tempSensor1 = dbCollections[0];
        tempSensor2 = dbCollections[1];
        doorSensor  = dbCollections[2];
    }

    /**
     * Processes an incoming MQTT message.
     *
     * @param topic the topic on which the message was received
     * @param c the MQTT message
     * @throws Exception if an error occurs while processing the message
     */
    @Override
    public void messageArrived(String topic, MqttMessage c) throws Exception {
        try {
            DBObject document_json;

            String mqttMessageString = addBackslashSpecialCharacters(c.toString());
            mqttMessageString = fixInvalidJSON(mqttMessageString);

            document_json = (DBObject) JSON.parse(mqttMessageString);

            if(document_json.containsField("SalaOrigem"))
                treatDoorSensorMessage(document_json);
            else
                treatTempSensorMessage(document_json, (Integer) document_json.get("Sensor"));

            documentLabel.append(c + "\n");

        } catch (JSONParseException e) {
            System.err.println("Error while JSON parsing");
            throw new Exception("Error while JSON parsing");

        } catch (Exception e) {
            System.err.println("Error treating message");
            throw new Exception("Error treating message");
        }
    }

    /**
     * Fixes invalid JSON by adding quotes around certain values.
     *
     * @param str The input string containing JSON data.
     * @return A string with corrected JSON format.
     */
    private String fixInvalidJSON(String str) {
        StringBuilder result = new StringBuilder();

        String[] jsonSeparateStrings = str.split(" ");

        result.append(jsonSeparateStrings[0]).append(" ").append(jsonSeparateStrings[1]);

        String needChangeString = jsonSeparateStrings[2];
        String[] needChangeStringArray = needChangeString.split(":");
        String[] bracketStringArray = needChangeStringArray[1].split(",");

        result.append(needChangeStringArray[0]).append(":\"").append(bracketStringArray[0]).append("\",");

        needChangeString = jsonSeparateStrings[3];
        needChangeStringArray = needChangeString.split(":");
        bracketStringArray = needChangeStringArray[1].split("}");

        result.append(needChangeStringArray[0]).append(":\"").append(bracketStringArray[0]).append("\"}");

        return result.toString();
    }

    /**
     * Adds a backslash before any special characters in the given string.
     *
     * @param str The input string.
     * @return The modified string with backslashes added before special characters.
     */
    private String addBackslashSpecialCharacters(String str) {
        StringBuilder result = new StringBuilder();

        for (int i = 0; i < str.length(); i++) {
            char ch = str.charAt(i);
            if (isSpecialCharacter(ch)) {
                // Append backslash before the special character
                result.append("\\").append(ch);
            } else {
                // Append the character as it is
                result.append(ch);
            }
        }

        return result.toString();
    }

    /**
     * Checks whether a given character is a special character.
     *
     * @param ch The character to be checked.
     * @return {@code true} if the character is a special character, {@code false} otherwise.
     */
    private boolean isSpecialCharacter(char ch) {
        //Define the set of special characters
        String specialCharacters = "!@#$%^&*()_=+[]|;<>?/";

        //Check if the character is a special character
        return specialCharacters.indexOf(ch) != -1;
    }

    /**
     * Inserts a temperature sensor message into the appropriate database collection.
     *
     * @param message the temperature sensor message to insert
     * @param sensor the sensor number
     */
    private void treatTempSensorMessage(DBObject message, int sensor) {
        if(sensor == 1) {
            tempSensor1.insert(message);
        } else { //Currently the sensor 2 takes wrong inputs (invalid inputs from mqtt)
            tempSensor2.insert(message);
        }
    }

    /**
     * Inserts a door sensor message into the database collection.
     *
     * @param message the door sensor message to insert
     */
    private void treatDoorSensorMessage(DBObject message) {
        doorSensor.insert(message);
    }

    /**
     * Called when the connection to the MQTT broker is lost.
     *
     * @param cause the reason for the connection loss
     */
    @Override
    public void connectionLost(Throwable cause) {

    }

    /**
     * Called when a message delivery to an MQTT client is complete.
     *
     * @param token the delivery token associated with the message delivery
     */
    @Override
    public void deliveryComplete(IMqttDeliveryToken token) {

    }
}
