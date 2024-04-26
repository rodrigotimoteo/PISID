package pt.iscte.mysql;

import org.bson.Document;
import org.eclipse.paho.client.mqttv3.*;
import pt.iscte.CommonUtilities;

import javax.swing.*;
import java.sql.CallableStatement;
import java.sql.Connection;

/**
 * Implements the MqttCallback interface for handling MQTT events and writing data to SQL.
 */
public class WriteToSQL implements MqttCallback {

    /**
     * Static connection to the MySQL database.
     */
    static Connection mySQLConnection;

    /**
     * Static instances of MQTT clients for temperature and maze sensors.
     */
    MqttClient mqttClientTemp;
    MqttClient mqttClientMaze;

    /**
     * Represents the name of the SQL table.
     */
    static String doorProcedure;

    static String tempProcedure;

    /**
     * JTextArea for displaying document labels.
     */
    static JTextArea documentLabel = new JTextArea("\n");

    public  static void main(String[] args) {
        documentLabel = CommonUtilities.createWindow("Data Bridge");

        new WriteToSQL().connectDatabase();
        new WriteToSQL().connectCloud();
    }

    /**
     * Connects to the MySQL database and displays connection information.
     */
    public void connectDatabase() {
        mySQLConnection = CommonUtilities.connectLocalDatabase();
        doorProcedure = CommonUtilities.getConfig("MySQL", "sqlDoorProcedure");
        tempProcedure = CommonUtilities.getConfig("MySQL", "sqlTempProcedure");

        if(mySQLConnection == null)
            System.exit(1);

        documentLabel.append("Connection To MariaDB Succeeded" + "\n");
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
     * Writes data to a MySQL database based on a specified SQL command generated from a JSON string.
     *
     * @param c a JSON string representing the data to be inserted
     */
    public void writeToMySQL(String c){
        String sqlCommand;

        if((Document.parse(c)).containsKey("SalaOrigem"))
            sqlCommand = getSQLCommand(c, doorProcedure);
        else
            sqlCommand = getSQLCommand(c, tempProcedure);

        System.out.println(sqlCommand);

        try {
            documentLabel.append(sqlCommand + "\n");
        } catch (Exception e) {
            System.err.println("Error appending to document label " + e);
        }

        try {
            CallableStatement statement = mySQLConnection.prepareCall(sqlCommand);
            boolean result = statement.execute();

            System.out.println(result);

            statement.close();

        } catch (Exception e){
            System.err.println("Error Inserting in the database. " + e);
            System.err.println(sqlCommand);
        }
    }

    /**
     * Constructs an SQL command string to execute a stored procedure with the provided JSON data.
     *
     * @param convertedJSON A string representing JSON data to be passed as arguments to the stored procedure.
     * @param procedure     The name of the stored procedure to be executed.
     * @return A string containing the SQL command to execute the specified stored procedure with the given JSON data.
     */
    private String getSQLCommand(String convertedJSON, String procedure) {
        StringBuilder sqlCommand = new StringBuilder();

        sqlCommand.append("{CALL ").append(procedure).append("('");

        StringBuilder values = new StringBuilder();
        String[] splitArray = convertedJSON.split(",");

        sqlCommand.append(extractTimestamp(splitArray[1])).append(", ");

        for (int i = 2; i < splitArray.length; i++) {
            String[] splitArray2 = splitArray[i].split(":");
            if (i > 2) values.append(", ");
            values.append(removeQuotes(splitArray2[1].trim()));
        }

        sqlCommand.append(values).append(")}");

        return sqlCommand.toString();
    }

    /**
     * Extracts the timestamp from the given time string.
     *
     * @param time The time string from which to extract the timestamp.
     * @return The extracted timestamp in the format "HH:mm:ss.SSS".
     *         Returns null if the time string format is invalid.
     */
    private String extractTimestamp(String time) {
        System.out.println(time);
        StringBuilder stringBuilder = new StringBuilder();

        String[] timeSeparated = time.split(" ");

        if(timeSeparated.length == 4) {
            stringBuilder.append(timeSeparated[2].substring(1)).append(" ");
            stringBuilder.append(timeSeparated[3], 0, 8).append("'");

            return stringBuilder.toString();
        }

        return null;
    }

    /**
     * Removes the leading and trailing quotes from the given string.
     *
     * @param string The string from which to remove quotes.
     * @return The string without leading and trailing quotes.
     */
    private String removeQuotes(String string) {
        StringBuilder stringBuilder = new StringBuilder();

        for(int i = 1; i < string.length(); i++) {
            if(string.charAt(i) == '"') break;

            stringBuilder.append(string.charAt(i));
        }

        return stringBuilder.toString();
    }

    /**
     * Handles incoming MQTT messages.
     *
     * @param s            the topic on which the message was received
     * @param mqttMessage  the MQTT message received
     */
    @Override
    public void messageArrived(String s, MqttMessage mqttMessage) {
        try {
            writeToMySQL(mqttMessage.toString());
            documentLabel.append(s + "\n");
        } catch (Exception e) {
            System.err.println("Error while treating received message " + e);
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
}
