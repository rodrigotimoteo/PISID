package pt.iscte.mqtt;

import com.mongodb.client.MongoCollection;
import org.bson.Document;
import org.bson.types.ObjectId;
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
    static MongoCollection<Document> tempSensor1;
    static MongoCollection<Document> tempSensor2;
    static MongoCollection<Document> doorSensor;
    static MongoCollection<Document> solutions;

    /**
     * Static variables representing the last known IDs for different types of sensors and solutions.
     * These variables are used to keep track of the last received ID for each sensor type.
     */
    static int tempSensor1LastId = 0;
    static int tempSensor2LastId = 0;
    static int doorSensorLastId  = 0;
    static int solutionsLastId   = 0;

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
     * Sets the JTextArea used for displaying document information.
     * This method allows injecting a JTextArea instance into the
     * ReadFromMQTTWriteToMongo class for displaying document information.
     *
     * @param documentLabel the JTextArea instance to be injected
     */
    public static void injectDocumentLabel(JTextArea documentLabel) {
        ReadFromMQTTWriteToMongo.documentLabel = documentLabel;
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
        MongoCollection<Document>[] dbCollections = CommonUtilities.connectMongo();

        tempSensor1 = dbCollections[0];
        tempSensor2 = dbCollections[1];
        doorSensor  = dbCollections[2];
        solutions   = dbCollections[3];

        checkIfExistsId();
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

        document = solutions.find().sort(new Document("_id", -1)).first();
        if(document != null) {
            solutionsLastId = Integer.parseInt(document.get("_id").toString(), 16);
            solutionsLastId++;
        }
    }

    /**
     * Processes an incoming MQTT message.
     *
     * @param topic the topic on which the message was received
     * @param c the MQTT message
     */
    @Override
    public void messageArrived(String topic, MqttMessage c) {
        try {
            if (c.toString().startsWith("{Solucao"))
                treatSolutionsMessage(c.toString(), false);
            else {
                Document document_json;

                String mqttMessageString = fixInvalidJSON(c.toString());

                document_json = Document.parse(mqttMessageString);

                if (document_json.containsKey("SalaOrigem"))
                    if (Integer.parseInt((String) document_json.get("SalaOrigem")) == 0)
                        treatSolutionsMessage(mqttMessageString, true);
                    else
                        treatDoorSensorMessage(document_json);
                else
                    treatTempSensorMessage(document_json, (String) document_json.get("Sensor"));
            }

            if(documentLabel != null) documentLabel.append(c + "\n");
        } catch (Exception e) {
            System.err.println("Error treating message" + c);
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

        str = str.replaceAll("\\s", "");

        String[] jsonSeparateStrings = str.split(":");

        // Appends the first part of the message {Hora:
        result.append(jsonSeparateStrings[0]).append(":").append('"');

        // Appends the second part of the message containing the date (since space have been removed the date input as
        // to be manual therefore the loop is hardcoded {Hora:"2024-04-19
        int i = 0;
        int countedNumbers = 0;

        if(jsonSeparateStrings[1].charAt(i) == '\'' || jsonSeparateStrings[1].charAt(i) == '"') i++;

        while(countedNumbers < 8) {
            result.append(jsonSeparateStrings[1].charAt(i++));
            if(Character.isDigit(jsonSeparateStrings[1].charAt(i))) countedNumbers++;
        }

        // Adds a space between the date and timestamp {Hora:"2024-04-19
        result.append(" ");

        // Adds the first part of the timestamp {Hora:"2024-04-19 16
        while(i < jsonSeparateStrings[1].length())
            result.append(jsonSeparateStrings[1].charAt(i++));

        // Adds the first colon, second part of timestamp and another colon {Hora:"2024-04-19 16:15:
        result.append(":").append(jsonSeparateStrings[2]).append(":");

        // Adds the rest of the timestamp until the quotes appear {Hora:"2024-04-19 16:15:40.616239
        i = 0;
        while(jsonSeparateStrings[3].charAt(i) != '"' && jsonSeparateStrings[3].charAt(i) != '\'')
            result.append(jsonSeparateStrings[3].charAt(i++));

        // Adds the quote and comma {Hora:"2024-04-19 16:15:40.616239",
        result.append('"').append(", ");

        // Adds the second field's name {Hora:"2024-04-19 16:15:40.616239", Leitura
        // The second field's name can be Leitura or SalaOrigem
        i += 2;
        while(i < jsonSeparateStrings[3].length())
            result.append(jsonSeparateStrings[3].charAt(i++));

        // Adds the colon and quote {Hora:"2024-04-19 16:15:40.616239", Leitura:"
        result.append(':').append('"');

        // Adds the value assigned to the second field {Hora:"2024-04-19 16:15:40.616239", Leitura:"39.613364
        i = 0;
        while(jsonSeparateStrings[4].charAt(i) != ',')
            result.append(jsonSeparateStrings[4].charAt(i++));

        // Adds the quote and the comma {Hora:"2024-04-19 16:15:40.616239", Leitura:"39.613364",
        result.append('"').append(", ");

        // Adds the third and final field's name {Hora:"2024-04-19 16:15:40.616239", Leitura:"39.613364", Sensor
        // Can be Sensor or SalaDestino
        i++;
        while(i < jsonSeparateStrings[4].length())
            result.append(jsonSeparateStrings[4].charAt(i++));

        // Adds the colon and the quote before the value {Hora:"2024-04-19 16:15:40.616239", Leitura:"39.613364", Sensor:"
        result.append(':').append('"');

        // Adds the final value {Hora:"2024-04-19 16:15:40.616239", Leitura:"39.613364", Sensor:"2
        i = 0;
        while(jsonSeparateStrings[5].charAt(i) != '}')
            result.append(jsonSeparateStrings[5].charAt(i++));

        // Adds the final quote and bracket
        result.append('"').append(" }");

        // Returns the final result
        return result.toString();
    }

    /**
     * Converts an integer into a valid 24-character hexadecimal string and returns it as an ObjectId.
     * If the resulting hexadecimal string is longer than 24 characters, it truncates it to 24 characters.
     * If the resulting hexadecimal string is shorter than 24 characters, it pads it with leading zeros.
     *
     * @param integer The integer value to be converted into a hexadecimal string.
     * @return An ObjectId constructed from the 24-character hexadecimal string representation of the integer.
     */
    private ObjectId getValidObjectId(int integer) {
        String hexString = String.format("%024x", integer);

        if (hexString.length() > 24) {
            hexString = hexString.substring(0, 24);
        } else if (hexString.length() < 24) {
            hexString = String.format("%0" + (24 - hexString.length()) + "d%s", 0, hexString);
        }

        return new ObjectId(hexString);
    }

    /**
     * Inserts a temperature sensor message into the appropriate database collection.
     *
     * @param message the temperature sensor message to insert
     * @param sensor the sensor number
     */
    private void treatTempSensorMessage(Document message, String sensor) {
        if(sensor.equals("1")) {
            message.append("_id", getValidObjectId(tempSensor1LastId++));
            tempSensor1.insertOne(message);
        } else {
            message.append("_id", getValidObjectId(tempSensor2LastId++));
            tempSensor2.insertOne(message);
        }
    }

    /**
     * Inserts a door sensor message into the database collection.
     *
     * @param message the door sensor message to insert
     */
    private void treatDoorSensorMessage(Document message) {
        message.append("_id", getValidObjectId(doorSensorLastId++));
        doorSensor.insertOne(message);
    }

    /**
     * Inserts a new solution message into the database collection.
     *
     * @param message the message representing a solution (beginning or ending of a test)
     */
    private void treatSolutionsMessage(String message, boolean parsed) {
        Document object;

        if(parsed) {
            object = new Document("StartDate", CommonUtilities.formatDate(System.currentTimeMillis()));
        } else {
            object = new Document("EndDate", CommonUtilities.formatDate(System.currentTimeMillis()));
            decodeSolutions(message, object);
        }

        object.append("_id", getValidObjectId(solutionsLastId++));
        solutions.insertOne(object);
    }

    /**
     * Decodes the solutions from the message and updates the provided DBObject with the decoded solutions.
     * The message format is assumed to be in the format "{Solucao:0-0-0-0-1-0-0-0-0-4}".
     * This method extracts the solution values from the message and updates the DBObject accordingly.
     *
     * @param message The message containing the solutions in the format "{Solucao:0-0-0-0-1-0-0-0-0-4}".
     * @param object  The DBObject to update with the decoded solutions.
     */
    private void decodeSolutions(String message, Document object) {
        for(int i = 9, sala = 1 ; i < message.length(); i++)
            if (Character.isDigit(message.charAt(i)))
                object.put("Sala" + sala++, message.charAt(i));
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
