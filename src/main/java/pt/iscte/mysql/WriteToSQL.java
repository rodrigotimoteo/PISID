package pt.iscte.mysql;

//import org.bson.Document;
//import org.bson.*;
//import org.bson.conversions.*;

//import org.json.JSONArray;
//import org.json.JSONObject;
//import org.json.JSONException;

import org.eclipse.paho.client.mqttv3.*;
import pt.iscte.CommonUtilities;

import javax.swing.*;
import java.sql.Connection;
import java.sql.Statement;


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
    static String sqlTable;

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
        mySQLConnection = CommonUtilities.connectDatabase();
        sqlTable = CommonUtilities.getConfig("MySQL", "sqlTable");

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
        MqttClient[] mqttClients = CommonUtilities.connectCloud(this, "MQTTCloud");

        mqttClientTemp = mqttClients[0];
        mqttClientMaze = mqttClients[1];
    }

    /**
     * Writes data to a MySQL database based on a specified SQL command generated from a JSON string.
     *
     * @param c a JSON string representing the data to be inserted
     */
    public void writeToMySQL(String c){
        String sqlCommand = getSQLCommand(c);
        //System.out.println(SqlCommando);

        try {
            documentLabel.append(sqlCommand + "\n");
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            Statement s = mySQLConnection.createStatement();
            int result = s.executeUpdate(sqlCommand);

            System.out.println(sqlCommand);

            s.close();
        } catch (Exception e){
            System.err.println("Error Inserting in the database . " + e);
            System.err.println(sqlCommand);
        }
    }

    /**
     * Generates an SQL command for inserting data into a specified table based on a JSON string.
     *
     * @param convertedJSON a JSON string representing the data to be inserted
     * @return a String containing the SQL insert command
     */
    private String getSQLCommand(String convertedJSON) {
        StringBuilder fields = new StringBuilder();
        StringBuilder values = new StringBuilder();
        String[] splitArray = convertedJSON.split(",");

        for (int i = 0; i < splitArray.length; i++) {
            String[] splitArray2 = splitArray[i].split(":");
            if (i == 0) fields = new StringBuilder(splitArray2[0]);
            else fields.append(", ").append(splitArray2[0]);
            if (i == 0) values = new StringBuilder(splitArray2[1]);
            else values.append(", ").append(splitArray2[1]);
        }

        fields = new StringBuilder(fields.toString().replace("\"", ""));
        return "Insert into " + sqlTable + " (" + fields.substring(1, fields.length()) + ") values (" +
                values.substring(0, values.length() - 1) + ");";
    }

    /**
     * Handles incoming MQTT messages.
     *
     * @param s            the topic on which the message was received
     * @param mqttMessage  the MQTT message received
     * @throws Exception   if an error occurs while processing the message
     */
    @Override
    public void messageArrived(String s, MqttMessage mqttMessage) throws Exception {
        try {
            //writeToMySQL(mqttMessage.toString());
            documentLabel.append(s + "\n");
        } catch (Exception e) {
            e.printStackTrace();
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
