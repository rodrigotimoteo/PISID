package pt.iscte.mqtt;

import com.mongodb.BasicDBObject;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.MongoCollection;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.eclipse.paho.client.mqttv3.*;
import org.json.JSONException;
import org.json.JSONObject;
import pt.iscte.CommonUtilities;

import javax.swing.*;
import java.io.*;
import java.sql.*;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.io.IOException;
import java.io.FileReader;
import java.util.concurrent.atomic.AtomicReference;

/**
 * Implements the MqttCallback interface for handling MQTT events and sending data to the broker.
 */
public class SendToMQTT implements MqttCallback {

    private static final String FILE_LOCATION = System.getProperty("user.dir") + "/lastIdValue";

    public static final int MAX_TEMP_ALLOWED_DEVIATION = 3;

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
    static MultiMap<Integer, ArrayList<Integer>> validPositions;

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
     * Value of the last temperature reading for each sensor
     */
    private double lastTemperatureReadingSensor1 = Integer.MIN_VALUE;
    private double lastTemperatureReadingSensor2 = Integer.MIN_VALUE;

    /**
     * Timestamp of the last sent sensors
     */
    private final AtomicReference<LocalDateTime> lastSentTimestampDoorSensor  = new AtomicReference<>();
    private final AtomicReference<LocalDateTime> lastSentTimestampTempSensor1 = new AtomicReference<>();
    private final AtomicReference<LocalDateTime> lastSentTimestampTempSensor2 = new AtomicReference<>();

    /**
     * Static variables representing the last known IDs for different types of sensors.
     * These variables are used to keep track of the last received ID for each sensor type.
     */
    static int tempSensor1LastId = 0;
    static int tempSensor2LastId = 0;
    static int doorSensorLastId  = 0;

    public static void main(String[] args) {
        documentLabel = CommonUtilities.createWindow("Send to MQTT");
        initFile();
        hasStoredId();

        new SendToMQTT().connectMazeSettings();
        new SendToMQTT().connectMongo();
        new SendToMQTT().connectCloud();
    }

    /**
     * Sets the JTextArea used for displaying document information.
     * This method allows injecting a JTextArea instance into the
     * ReadFromMQTTWriteToMongo class for displaying document information.
     *
     * @param documentLabel the JTextArea instance to be injected
     */
    public static void injectDocumentLabel(JTextArea documentLabel) {
        SendToMQTT.documentLabel = documentLabel;
    }


    /**
     * Initializes the file used for storing the last ID value.
     * If the file does not exist, it creates a new one.
     * The file is created relative to the project's source directory.
     */
    public static void initFile() {
        try {
            idStorageFile = new File(FILE_LOCATION);
            boolean fileCreated = idStorageFile.createNewFile();
            if(fileCreated) System.out.println("File created!");
            else System.out.println("File already exists!");
        } catch (IOException e) {
            System.err.println("Error initializing file " + e);
        }
    }

    /**
     * Connects to the MySQL database for maze settings, retrieves corridor information,
     * and builds the maze map.
     */
    public void connectMazeSettings() {
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
            validPositions = new MultiMap<>();

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

        checkIfExistsId();

        ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1);
        executorService.scheduleAtFixedRate(() -> {
            try {
                fetchMongo();
            } catch (Exception e) {
                System.err.println("There was an error while fetching information from mongoDB database " + e);
                e.printStackTrace();
            }
        }, 5000, 500, TimeUnit.MILLISECONDS);
    }

    /**
     * Checks if the IDs exist in the database collections and updates the last known IDs accordingly.
     * This method queries the database collections for each sensor type and solutions,
     * sorts the documents by ID in descending order, and retrieves the first document.
     * If a document is found, it updates the corresponding last known ID by converting
     * the hexadecimal string ID to an integer and incrementing it by one.
     */
    private void checkIfExistsId() {
        Document document = tempSensor1.find().sort(new Document("_id", -1)).first();
        if(document != null) {
            tempSensor1LastId = Integer.parseInt(document.get("_id").toString(), 16);
            tempSensor1LastId++;
        }

        document = tempSensor2.find().sort(new Document("_id", -1)).first();
        if(document != null) {
            tempSensor2LastId = Integer.parseInt(document.get("_id").toString(), 16);
            tempSensor2LastId++;
        }

        document = doorSensor.find().sort(new Document("_id", -1)).first();
        if(document != null) {
            doorSensorLastId = Integer.parseInt(document.get("_id").toString(), 16);
            doorSensorLastId++;
        }
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

            if (isIdProcessed(documentId, document)) {
                if (!filter(document)) {
                    if(document.containsKey("SalaOrigem"))
                        doorSensorLastId++;
                    else
                        if(Integer.parseInt((String) document.get("Sensor")) == 1)
                            tempSensor1LastId++;
                        else
                            tempSensor2LastId++;

                    continue;
                }

                publishSensor(document.toJson());

                //Update the last retrieval timestamp
                lastRetrievalTimestamp = Objects.requireNonNull(CommonUtilities.parseDate(document.get("Hora").toString())).getTime();
                addToId(document);
            }
        }
    }

    private boolean isIdProcessed(String id, Document document) {
        if(document.containsKey("SalaOrigem"))
            return Integer.parseInt(id, 16) > doorSensorLastId;
        else
            if(Integer.parseInt((String) document.get("Sensor")) == 1)
                return Integer.parseInt(id, 16) > tempSensor1LastId;
            if(Integer.parseInt((String) document.get("Sensor")) == 2)
                return Integer.parseInt(id, 16) > tempSensor2LastId;

        return false;
    }

    private void addToId(Document document) {
        if(document.containsKey("SalaOrigem"))
            doorSensorLastId++;
        else
        if(Integer.parseInt((String) document.get("Sensor")) == 1)
            tempSensor1LastId++;
        else
            tempSensor2LastId++;
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

            storeMessageId();

            if(documentLabel != null) documentLabel.append(mqttMessage + "\n");
        } catch (MqttException e) {
            System.err.println("There was an error reading or sending the MQTT message");
        }
    }

    /**
     * Publishes a new message to the temperature sensors' MQTT topic
     *
     * @param mqttMessage MQTT Message to broadcast to the broker
     * @throws MqttException What type of error occurred in the MQTT connection
     */
    private void treatTempSensorMessage(MqttMessage mqttMessage) throws MqttException {
        mqttClientTemp.publish(CommonUtilities.getConfig("MQTT", "MQTTTopicTemp"), mqttMessage);
    }

    /**
     * Publishes a new message to the door sensor's MQTT topic
     *
     * @param mqttMessage MQTT Message to broadcast to the broker
     * @throws MqttException What type of error occurred in the MQTT connection
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
        if(token.isComplete()) {
            System.out.println(token.getMessageId() + "\n" + token.getResponse());
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
     */
    public void storeMessageId() {
        JSONObject jsonObject = new JSONObject();

        jsonObject.put("tempSensor1LastId", Integer.toHexString(tempSensor1LastId));
        jsonObject.put("tempSensor2LastId", Integer.toHexString(tempSensor2LastId));
        jsonObject.put("doorSensorLastId", Integer.toHexString(doorSensorLastId));

        try {
            BufferedWriter writer = new BufferedWriter(new FileWriter(idStorageFile));

            writer.write(jsonObject.toString());
            writer.close();
        } catch (IOException e) {
            System.err.println("File could not be created to " + idStorageFile);
            throw new RuntimeException(e);
        }
    }

    /**
     * Retrieves the stored ID from the designated storage file.
     */
    public static void hasStoredId() {
        try {
            if (idStorageFile.exists()) {
                BufferedReader reader = new BufferedReader(new FileReader(idStorageFile));

                StringBuilder jsonString = new StringBuilder();
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonString.append(line);
                }

                if(!jsonString.toString().isEmpty()) {
                    JSONObject jsonObject = new JSONObject(jsonString.toString());


                JSONObject jsonObject = new JSONObject(jsonString.toString());

                reader.close();
                tempSensor1LastId = Integer.parseInt(jsonObject.getString("tempSensor1LastId"), 16);
                tempSensor2LastId = Integer.parseInt(jsonObject.getString("tempSensor2LastId"), 16);
                doorSensorLastId  = Integer.parseInt(jsonObject.getString("doorSensorLastId"), 16);

                }

             reader.close();
            }
        } catch (IOException e) {
            System.err.println("File could not be read");
        } catch (JSONException e) {
            System.err.println("File could not be parsed");
            e.printStackTrace();
        }
    }

    /**
     * Filters the document based on its timestamp and content.
     *
     * @param document The document to filter.
     * @return {@code true} if the document meets the filtering criteria, {@code false} otherwise.
     */
    private boolean filter(Document document) {
        //Filtering the date if withing 7 days and valid
        try {
            LocalDateTime documentDateTime = LocalDateTime.parse((CharSequence) document.get("Hora"),DateTimeFormatter.
                    ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS"));
            LocalDateTime currentDateTime  = LocalDateTime.now();

            Duration duration = Duration.between(documentDateTime, currentDateTime);

            if (duration.abs().toDays() >= 7) return false;
        } catch (DateTimeParseException e) {
            System.err.println("Invalid date: " + document.get("Hora"));
            return false;
        }

        if      (document.containsKey("SalaOrigem")) return filterDoorSensor(document);
        else if (document.containsKey("Leitura")) return filterTemperatureSensor(document);

        return false;
    }

    /**
     * Filters the document from a door sensor based on its content mainly validity of movement and duplicate verification
     * based on document's timestamp
     *
     * @param document The document from the door sensor
     * @return {@code true} if the document meets the filtering criteria {@code false} otherwise
     */
    private boolean filterDoorSensor(Document document) {
        //Filter duplicates based on dates
        if(filterDuplicatesBasedOnDate(document, lastSentTimestampDoorSensor))
            return false;


        //Check if number of rooms is correct
        int originRoom, destinationRoom;

        originRoom = Integer.parseInt((String) document.get("SalaOrigem"));
        destinationRoom = Integer.parseInt((String) document.get("SalaDestino"));

        if(originRoom < 1 || originRoom > 10 || destinationRoom < 1 || destinationRoom > 10) return false;

        return checkMovement(originRoom, destinationRoom);
    }

    /**
     * Checks if the movement from one room to another is valid.
     *
     * @param originRoom The room from which the movement originates.
     * @param destinationRoom The room to which the movement is intended.
     * @return {@code true} if the movement is valid, {@code false} otherwise.
     */
    private boolean checkMovement(int originRoom, int destinationRoom) {
        //Check if movement is valid
        List<ArrayList<Integer>> possibleDestinations;

        if(!validPositions.containsKey(originRoom)) return false;

        possibleDestinations = validPositions.get(originRoom);

        for(ArrayList<Integer> destination : possibleDestinations)
            if(destination.getFirst() == destinationRoom) return true;

        return false;
    }

    /**
     * Filters temperature sensor data to ensure validity.
     *
     * @param document The document containing temperature sensor data.
     * @return {@code true} if the temperature data is valid; {@code false} otherwise.
     */
    private boolean filterTemperatureSensor(Document document) {
        //Check if values are valid
        double temperature;

        try {
            temperature = Double.parseDouble((String) document.get("Leitura"));
        } catch (NumberFormatException e) {
            System.err.println("Invalid value for temperature, error parsing " + document.get("Leitura"));

            return false;
        } catch (NullPointerException e) {
            System.err.println("No value given");

            return false;
        }

        int sensor = Integer.parseInt((String) document.get("Sensor"));

        //Check temperature variations for unconformities and duplicates based on dates
        if(sensor == 1) {
            if(filterDuplicatesBasedOnDate(document, lastSentTimestampTempSensor1)) return false;

            if(lastTemperatureReadingSensor1 == Integer.MIN_VALUE)
                lastTemperatureReadingSensor1 = temperature;

            if(Math.abs(lastTemperatureReadingSensor1 - temperature) < MAX_TEMP_ALLOWED_DEVIATION) {
                lastTemperatureReadingSensor1 = temperature;
                return true;
            } else return false;
        }
        else if(sensor == 2) {
            if(filterDuplicatesBasedOnDate(document, lastSentTimestampTempSensor2)) return false;

            if(lastTemperatureReadingSensor2 == Integer.MIN_VALUE)
                lastTemperatureReadingSensor2 = temperature;

            if(Math.abs(lastTemperatureReadingSensor2 - temperature) < MAX_TEMP_ALLOWED_DEVIATION) {
                lastTemperatureReadingSensor1 = temperature;
                return true;
            } else return false;
        }

        return false;
    }


    /**
     * Filters duplicate documents based on date.
     *
     * @param document The document to check for duplicates.
     * @param lastSentDateTime The timestamp of the last sent document.
     * @return {@code true} if the document is not a duplicate based on date, {@code false} otherwise.
     * @throws DateTimeParseException If the date in the document cannot be parsed.
     */
    private boolean filterDuplicatesBasedOnDate(Document document, AtomicReference<LocalDateTime> lastSentDateTime) {
        if(lastSentDateTime.get() == null) return false;

        try {
            LocalDateTime documentDateTime = LocalDateTime.parse((CharSequence) document.get("Hora"),DateTimeFormatter.
                    ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS"));

            if(lastSentDateTime.get().equals(documentDateTime)) return true;

            lastSentDateTime.set(documentDateTime);
        } catch (DateTimeParseException e) {
            System.err.println("Invalid date: " + document.get("Hora"));
            return true;
        }



        //Check if number of rooms is correct
        int originRoom, destinationRoom;

        originRoom = Integer.parseInt((String) document.get("SalaOrigem"));
        destinationRoom = Integer.parseInt((String) document.get("SalaDestino"));

        if(originRoom < 1 || originRoom > 10 || destinationRoom < 1 || destinationRoom > 10) return false;

        return checkMovement(originRoom, destinationRoom);
    }

    /**
     * Checks if the movement from one room to another is valid.
     *
     * @param originRoom The room from which the movement originates.
     * @param destinationRoom The room to which the movement is intended.
     * @return {@code true} if the movement is valid, {@code false} otherwise.
     */
    private boolean checkMovement(int originRoom, int destinationRoom) {
        //Check if movement is valid
        List<ArrayList<Integer>> possibleDestinations;

        if(!validPositions.containsKey(originRoom)) return false;

        possibleDestinations = validPositions.get(originRoom);

        for(ArrayList<Integer> destination : possibleDestinations)
            if(destination.getFirst() == destinationRoom) return true;

        return false;
    }

    /**
     * Filters temperature sensor data to ensure validity.
     *
     * @param document The document containing temperature sensor data.
     * @return {@code true} if the temperature data is valid; {@code false} otherwise.
     */
    private boolean filterTemperatureSensor(Document document) {
        //Check if values are valid
        double temperature;

        try {
            temperature = Double.parseDouble((String) document.get("Leitura"));
        } catch (NumberFormatException e) {
            System.err.println("Invalid value for temperature, error parsing " + document.get("Leitura"));

            return false;
        } catch (NullPointerException e) {
            System.err.println("No value given");

            return false;
        }

        int sensor = Integer.parseInt((String) document.get("Sensor"));

        //Check temperature variations for unconformities and duplicates based on dates
        if(sensor == 1) {
            if(filterDuplicatesBasedOnDate(document, lastSentTimestampTempSensor1)) return false;

            if(lastTemperatureReadingSensor1 == Integer.MIN_VALUE)
                lastTemperatureReadingSensor1 = temperature;

            if(Math.abs(lastTemperatureReadingSensor1 - temperature) < MAX_TEMP_ALLOWED_DEVIATION) {
                lastTemperatureReadingSensor1 = temperature;
                return true;
            } else return false;
        }
        else if(sensor == 2) {
            if(filterDuplicatesBasedOnDate(document, lastSentTimestampTempSensor2)) return false;

            if(lastTemperatureReadingSensor2 == Integer.MIN_VALUE)
                lastTemperatureReadingSensor2 = temperature;

            if(Math.abs(lastTemperatureReadingSensor2 - temperature) < MAX_TEMP_ALLOWED_DEVIATION) {
                lastTemperatureReadingSensor1 = temperature;
                return true;
            } else return false;
        }

        return false;
    }


    /**
     * Filters duplicate documents based on date.
     *
     * @param document The document to check for duplicates.
     * @param lastSentDateTime The timestamp of the last sent document.
     * @return {@code true} if the document is not a duplicate based on date, {@code false} otherwise.
     * @throws DateTimeParseException If the date in the document cannot be parsed.
     */
    private boolean filterDuplicatesBasedOnDate(Document document, AtomicReference<LocalDateTime> lastSentDateTime) {
        if(lastSentDateTime.get() == null) return false;

        try {
            LocalDateTime documentDateTime = LocalDateTime.parse((CharSequence) document.get("Hora"),DateTimeFormatter.
                    ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS"));

            if(lastSentDateTime.get().equals(documentDateTime)) return true;

            lastSentDateTime.set(documentDateTime);
        } catch (DateTimeParseException e) {
            System.err.println("Invalid date: " + document.get("Hora"));
            return true;
        }


        return false;
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
