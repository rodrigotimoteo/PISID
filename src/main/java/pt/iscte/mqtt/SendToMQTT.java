package pt.iscte.mqtt;

import com.mongodb.BasicDBObject;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.eclipse.paho.client.mqttv3.*;
import pt.iscte.CommonUtilities;

import javax.swing.*;
import java.io.*;
import java.sql.*;
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
    static MongoCollection<Document> tempSensor1;
    static MongoCollection<Document> tempSensor2;
    static MongoCollection<Document> doorSensor;

    /**
     * Static reference to the maze configuration hosted in provided mySQL DB
     */
    static MultiMap validPositions;

    /**
     * JTextArea for displaying document labels.
     */
    static JTextArea documentLabel = new JTextArea("\n");

    /**
     * Stores a static reference to the file dedicated to storing the last ID sent
     */
    static File idStorageFile;

    /**
     * ID of the last retrieval operation.
     */
    private static String lastSentId;

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
        initFile();
        hasStoredId();

        new SendToMQTT().connectMazeSettings();
        new SendToMQTT().connectMongo();
        new SendToMQTT().connectCloud();
    }

    /**
     * Initializes the file used for storing the last ID value.
     * If the file does not exist, it creates a new one.
     * The file is created relative to the project's source directory.
     */
    private static void initFile() {
        try {
            idStorageFile = new File(new File("").getPath()+"src/main/java/pt/iscte/mqtt/lastIdValue");
            idStorageFile.createNewFile();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Connects to the MySQL database for maze settings, retrieves corridor information,
     * and builds the maze map.
     */
    private void connectMazeSettings() {
        Connection mySQLConnection = CommonUtilities.connectMazeSettingDatabase();

        if (mySQLConnection == null) {
            System.err.println("mySQL Connect Failed");
            System.exit(1);
        }

        String sqlCommand = "SELECT * FROM corredor";

        try {
            PreparedStatement statement = mySQLConnection.prepareStatement(sqlCommand);
            ResultSet result = statement.executeQuery();

            buildMazeMap(result);

            statement.close();

        } catch (Exception e){
            System.err.println("Error Inserting in the database. " + e);
            System.err.println(sqlCommand);
        }
    }

    /**
     * Constructs a maze map from the ResultSet containing room and distance information.
     *
     * @param result the ResultSet containing room and distance information
     */
    private void buildMazeMap(ResultSet result) {
        try {
            validPositions = new MultiMap<Integer, ArrayList<Integer>>();

            while(result.next()) {
                ArrayList<Integer> arrayWithRoomAndDistance = new ArrayList<>();

                arrayWithRoomAndDistance.add(result.getInt("salab"));
                arrayWithRoomAndDistance.add(result.getInt("centimetro"));

                validPositions.put(result.getInt("salaa"), arrayWithRoomAndDistance);
            }

        } catch (SQLException e) {
            System.err.println("Error reading result information. " + e);
        }
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
        MongoCollection<Document>[] dbCollections = CommonUtilities.connectMongo();

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
        Document match, sort;

        if(lastSentId == null || lastSentId.isEmpty()) {
            match = new Document("$match", new BasicDBObject("Hora", new BasicDBObject("$gt",
                    CommonUtilities.formatDate(lastRetrievalTimestamp))));
            sort = new Document("$sort", new BasicDBObject("Hora", 1));
        } else {
            ObjectId lastSentObjectId = new ObjectId(lastSentId);

            match = new Document("$match", new BasicDBObject("_id", new BasicDBObject("$gt", lastSentObjectId)));
            sort = new Document("$sort", new BasicDBObject("_id", 1));
        }

        // Construct the aggregation pipeline
        Document[] pipeline = {match, sort};

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
    private void extractSensorData(Document[] pipeline, MongoCollection<Document> collection) {
        //Execute the aggregation pipeline and process the result
        AggregateIterable<Document> output = collection.aggregate(Arrays.asList(pipeline));

        for (Document document : output) {
            String documentId = document.get("_id").toString();
            if (!processedIds.contains(documentId)) {
                publishSensor(document.toJson());

                //Update the last retrieval timestamp
                lastRetrievalTimestamp = Objects.requireNonNull(CommonUtilities.parseDate(document.get("Hora").toString())).getTime();
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
            if((Document.parse(sensorData)).containsKey("SalaOrigem"))
                treatDoorSensorMessage(mqttMessage);
            else
                treatTempSensorMessage(mqttMessage);

            storeMessageId((Document.parse(sensorData)).get("_id").toString());
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
        try {
            System.out.println(token.getMessage());
        } catch (MqttException e) {
            throw new RuntimeException(e);
        }
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

    /**
     * Stores the provided message ID in the designated storage file.
     *
     * @param messageID The message ID to be stored.
     */
    public void storeMessageId(String messageID) {
        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(idStorageFile));

            writer.write(messageID);
            writer.close();
        } catch (IOException e) {
            System.err.println("File could not be created to " + idStorageFile);
            throw new RuntimeException(e);
        }
    }

    /**
     * Retrieves the stored ID from the designated storage file.
     */
    private static void hasStoredId() {
        try {
            if (idStorageFile.exists()) {
                BufferedReader reader = new BufferedReader(new FileReader(idStorageFile));
                lastSentId = reader.readLine();
                reader.close();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    /**
     * A data structure representing a multimap, which allows multiple values to be associated with a single key.
     * Used to store the available connections between rooms for error checking
     *
     * @param <KeyType>   the type of keys in the multimap
     * @param <ValueType> the type of values in the multimap
     */
    private static class MultiMap<KeyType, ValueType> {

        /** The underlying map storing the key-value pairs. */
        private final Map<KeyType, List<ValueType>> map;

        /**
         * Constructs a new empty multimap.
         */
        public MultiMap() {
            this.map = new HashMap<>();
        }

        /**
         * Associates the specified value with the specified key in this multimap.
         *
         * @param key   the key with which the specified value is to be associated
         * @param value the value to be associated with the specified key
         */
        public void put(KeyType key, ValueType value) {
            map.computeIfAbsent(key, k -> new ArrayList<>()).add(value);
        }

        /**
         * Returns a list of values to which the specified key is mapped, or an empty list if the key is not present.
         *
         * @param key the key whose associated values are to be returned
         * @return a list of values to which the specified key is mapped, or an empty list if the key is not present
         */
        public List<ValueType> get(KeyType key) {
            return map.getOrDefault(key, Collections.emptyList());
        }

        /**
         * Returns true if this multimap contains the specified key.
         *
         * @param key the key whose presence in this multimap is to be tested
         * @return true if this multimap contains the specified key
         */
        public boolean containsKey(KeyType key) {
            return map.containsKey(key);
        }

        /**
         * Returns true if this multimap contains the specified value associated with the specified key.
         *
         * @param key   the key whose associated values are to be searched
         * @param value the value whose presence in this multimap is to be tested
         * @return true if this multimap contains the specified value associated with the specified key
         */
        public boolean containsValue(KeyType key, ValueType value) {
            List<ValueType> values = map.get(key);
            return values != null && values.contains(value);
        }

        /**
         * Returns a set view of the keys contained in this multimap.
         *
         * @return a set view of the keys contained in this multimap
         */
        public Set<KeyType> keySet() {
            return map.keySet();
        }

        /**
         * Returns a collection view of the values contained in this multimap.
         *
         * @return a collection view of the values contained in this multimap
         */
        public Collection<List<ValueType>> values() {
            return map.values();
        }

        /**
         * Returns a set view of the key-value mappings contained in this multimap.
         *
         * @return a set view of the key-value mappings contained in this multimap
         */
        public Set<Map.Entry<KeyType, List<ValueType>>> entrySet() {
            return map.entrySet();
        }

        /**
         * Returns the number of key-value mappings in this multimap.
         *
         * @return the number of key-value mappings in this multimap
         */
        public int size() {
            return map.size();
        }

        /**
         * Returns true if this multimap contains no key-value mappings.
         *
         * @return true if this multimap contains no key-value mappings
         */
        public boolean isEmpty() {
            return map.isEmpty();
        }

        /**
         * Removes all the key-value mappings from this multimap.
         */
        public void clear() {
            map.clear();
        }
    }


}
