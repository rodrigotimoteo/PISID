package pt.iscte.mqtt;

import com.mongodb.AggregationOutput;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import com.mongodb.util.JSON;
import org.eclipse.paho.client.mqttv3.*;
import pt.iscte.CommonUtilities;

import javax.swing.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Implements the MqttCallback interface for handling MQTT events and sending data to the broker.
 */
public class SendToMQTT implements MqttCallback {

    /**
     * Static instances of MQTT clients for temperature and maze sensors.
     */
    static MqttClient mqttClientTemp;
    static MqttClient mqttClientMaze;

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

    /**
     * Timestamp of the last retrieval operation.
     */
    private long lastRetrievalTimestamp = System.currentTimeMillis();

    /**
     * Set for storing processed IDs.
     */
    private final Set<String> processedIds = new HashSet<>();


    public static void main(String[] args) {
        documentLabel = CommonUtilities.createWindow("Send to MQTT");

        new SendToMQTT().connectMongo();
        new SendToMQTT().connectCloud();
    }

    /**
     * Connects to the MQTT broker using the configuration from the Configuration.ini file.
     *
     * @throws RuntimeException if an error occurs during connection to the MQTT broker
     */
    public void connectCloud() {
        MqttClient[] mqttClients = CommonUtilities.connectCloud(this, "MQTT");

        mqttClientTemp = mqttClients[0];
        mqttClientMaze = mqttClients[1];
    }

    /**
     * Connects to the MongoDB server, initializes database collections and initializes a data extraction
     * loop every 500ms
     */
    public void connectMongo() {
        DBCollection[] dbCollections = CommonUtilities.connectMongo();

        tempSensor1 = dbCollections[0];
        tempSensor2 = dbCollections[1];
        doorSensor  = dbCollections[2];

        ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1);
        executorService.scheduleAtFixedRate(() -> {
            try {
                fetchMongo();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 5000, 500, TimeUnit.MILLISECONDS);
    }

    /**
     * Fetches sensor data from MongoDB and extracts relevant information.
     */
    private void fetchMongo() {
        BasicDBObject match = new BasicDBObject("$match", new BasicDBObject("Hora", new BasicDBObject("$gt", formatDate(lastRetrievalTimestamp))));
        BasicDBObject sort = new BasicDBObject("$sort", new BasicDBObject("Hora", 1));

        // Construct the aggregation pipeline
        DBObject[] pipeline = {match, sort};

        extractSensorData(pipeline, tempSensor1);
        extractSensorData(pipeline, tempSensor2);
        extractSensorData(pipeline, doorSensor);
    }

    /**
     * Executes an aggregation pipeline on the specified collection to extract sensor data, based on the current
     * timestamp
     *
     * @param pipeline the aggregation pipeline to execute
     * @param collection the MongoDB collection to query
     */
    private void extractSensorData(DBObject[] pipeline, DBCollection collection) {
        //Execute the aggregation pipeline and process the result
        AggregationOutput output = collection.aggregate(Arrays.asList(pipeline));
        for (DBObject dbObject : output.results()) {
            String documentId = dbObject.get("_id").toString();
            if (!processedIds.contains(documentId)) {
                System.out.println(dbObject);
                publishSensor(dbObject.toString());

                //Update the last retrieval timestamp
                lastRetrievalTimestamp = Objects.requireNonNull(parseDate(dbObject.get("Hora").toString())).getTime();
                processedIds.add(documentId);
            }
        }
    }

    /**
     * Publishes the given sensor data to the MQTT broker.
     *
     * @param sensorData the sensor data to publish
     */
    public void publishSensor(String sensorData) {
        try {
            MqttMessage mqttMessage = new MqttMessage();
            mqttMessage.setPayload(sensorData.getBytes());

            //Check if message is sensor data or not
            if(((DBObject) JSON.parse(sensorData)).containsField("SalaOrigem"))
                treatDoorSensorMessage(mqttMessage);
            else
                treatTempSensorMessage(mqttMessage);

            documentLabel.append(mqttMessage + "\n");
        } catch (MqttException e) {
            e.printStackTrace();
        }
    }

    /**
     * Publishes a new message to the temperature sensors' MQTT topic
     *
     * @param mqttMessage MQTT Message to broadcast to the broker
     * @throws MqttException What type of error occured in the MQTT connection
     */
    private void treatTempSensorMessage(MqttMessage mqttMessage) throws MqttException {
        mqttClientTemp.publish(CommonUtilities.getConfig("MQTT", "MQTTTopicTemp"), mqttMessage);
    }

    /**
     * Publishes a new message to the door sensor's MQTT topic
     *
     * @param mqttMessage MQTT Message to broadcast to the broker
     * @throws MqttException What type of error occured in the MQTT connection
     */
    private void treatDoorSensorMessage(MqttMessage mqttMessage) throws MqttException {
        mqttClientMaze.publish(CommonUtilities.getConfig("MQTT", "MQTTTopicMaze"), mqttMessage);
    }

    /**
     * Formats the timestamp into the specified date-time format.
     *
     * @param timestamp the timestamp to format, represented as milliseconds since the epoch
     * @return a string representation of the formatted date-time
     */
    private String formatDate(long timestamp) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSSSSS");
        return sdf.format(new Date(timestamp));
    }

    /**
     * Parses the given date string into a Date object using the specified date-time format.
     *
     * @param dateString the string representation of the date to parse
     * @return the Date object representing the parsed date, or null if parsing fails
     */
    private Date parseDate(String dateString) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            return sdf.parse(dateString);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
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

    /**
     * Invoked when a message arrives from the MQTT broker.
     *
     * @param topic the topic on which the message was received
     * @param message the MQTT message received
     */
    @Override
    public void messageArrived(String topic, MqttMessage message){

    }

}
