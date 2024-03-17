
package pt.iscte.mqtt;

import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.util.JSON;
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
            document_json = (DBObject) JSON.parse(c.toString());
            if(document_json.containsField("SalaOrigem"))
                treatDoorSensorMessage(document_json);
            else
                treatTempSensorMessage(document_json, (Integer) document_json.get("Sensor"));

            documentLabel.append(c + "\n");
        } catch (Exception e) {
            e.printStackTrace();
        }
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
