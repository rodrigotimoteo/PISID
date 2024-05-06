package pt.iscte.mysql;

import org.bson.Document;
import org.eclipse.paho.client.mqttv3.*;
import pt.iscte.CommonUtilities;

import javax.swing.*;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;

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
    MqttClient mqttSolutions;

    /**
     * Represents the name of the SQL table.
     */
    static String doorProcedure;
    static String tempProcedure;
    static String initTestProcedure;
    static String createTestProcedure;
    static String endTestProcedure;

    /**
     * Represents the email to be used to create tests
     */
    final String EMAIL = CommonUtilities.getConfig("MySQL", "sqlDatabaseUser");
    int TEST_NUMBER = 0;
    int NUMBER_OF_RATS = 5;
    int LIMIT_MOUSE_PER_ROOM = 5;
    int TIME_WITHOUT_MOVEMENT = 15;
    int IDEAL_TEMP = 10;
    int MAX_TEMP_DEVIATION = 20;

    /**
     * JTextArea for displaying document labels.
     */
    static JTextArea documentLabel = new JTextArea("\n");

    /**
     * Defines whether to use automatic testing
     */
    private static final boolean ACTIVE_AUTOMATIC_TESTS = false;


    public  static void main(String[] args) {
        documentLabel = CommonUtilities.createWindow("Data Bridge");

        new WriteToSQL().connectDatabase();
        new WriteToSQL().connectCloud();
    }

    /**
     * Sets the JTextArea used for displaying document information.
     * This method allows injecting a JTextArea instance into the
     * ReadFromMQTTWriteToMongo class for displaying document information.
     *
     * @param documentLabel the JTextArea instance to be injected
     */
    public static void injectDocumentLabel(JTextArea documentLabel) {
        WriteToSQL.documentLabel = documentLabel;
    }

    /**
     * Connects to the MySQL database and displays connection information.
     */
    public void connectDatabase() {
        mySQLConnection = CommonUtilities.connectLocalDatabase();
        doorProcedure = CommonUtilities.getConfig("MySQL", "sqlDoorProcedure");
        tempProcedure = CommonUtilities.getConfig("MySQL", "sqlTempProcedure");
        createTestProcedure = CommonUtilities.getConfig("MySQL", "sqlCreateTestProcedure");
        initTestProcedure = CommonUtilities.getConfig("MySQL", "sqlInitTestProcedure");
        endTestProcedure = CommonUtilities.getConfig("MySQL", "sqlFinishTestProcedure");

        TEST_NUMBER = getRunningTest();

        if(mySQLConnection == null)
            System.exit(1);

        if(documentLabel != null) documentLabel.append("Connection To MariaDB Succeeded" + "\n");
        else System.out.println("Connection To MariaDB Succeeded");
    }

    /**
     * Retrieves the ID of the currently running test from the database.
     * If the running test ID is null, retrieves the ID of the latest test instead.
     *
     * @return The ID of the currently running test, or the ID of the latest test if the running test ID is null.
     *         Returns 0 if an error occurs or if no test ID is found.
     */
    private int getRunningTest() {
        try {
            CallableStatement statement = mySQLConnection.prepareCall("{? = CALL GetRunningTest()}");
            statement.registerOutParameter(1, Types.INTEGER);

            statement.execute();

            int result = statement.getInt(1);

            if(statement.wasNull()) {
                statement = mySQLConnection.prepareCall("{? = Call GetLatestTest()}");
                statement.registerOutParameter(1, Types.INTEGER);

                statement.execute();

                result = statement.getInt(1);
            }

            return result;
        } catch (Exception e) {
            System.err.println("Error getting running test!");
            e.printStackTrace();
        }

        return 0;
    }


    /**
     * Connects to the MQTT broker using the configuration from the Configuration.ini file.
     *
     * @throws RuntimeException if an error occurs during connection to the MQTT broker
     */
    public void connectCloud() {
        MqttClient[] mqttClients = CommonUtilities.connectCloud(this, "MQTT", true, "MQTT");

        mqttClientTemp = mqttClients[0];
        mqttClientMaze = mqttClients[1];
        mqttSolutions  = mqttClients[2];
    }

    /**
     * Writes data to a MySQL database based on a specified SQL command generated from a JSON string.
     *
     * @param c a JSON string representing the data to be inserted
     */
    public void writeToMySQL(String c){
        if((Document.parse(c)).containsKey("SalaOrigem"))
            executeCommand(getSQLCommand(c, doorProcedure));
        else if((Document.parse(c)).containsKey("Leitura"))
            executeCommand(getSQLCommand(c, tempProcedure));
        else if(ACTIVE_AUTOMATIC_TESTS)
            if((Document.parse(c)).containsKey("StartDate")) {
                TEST_NUMBER = getRunningTest();
                executeCommand(getSQLCommandCreateTest(createTestProcedure));

                int new_test_number = getRunningTest();
                if(TEST_NUMBER != new_test_number) TEST_NUMBER = new_test_number;

                executeCommand(setTestStatus(initTestProcedure, false));
            } else
                executeCommand(setTestStatus(endTestProcedure, true));
    }

    /**
     * Executes the given SQL command.
     * Appends the command to the document label if available, or prints it to the console otherwise.
     * Prepares and executes a CallableStatement with the given SQL command.
     * Prints the result of execution to the console.
     *
     * @param sqlCommand The SQL command to execute.
     */
    private void executeCommand(String sqlCommand) {
        try {
            if(documentLabel != null) documentLabel.append(sqlCommand + "\n");
            else System.out.println(sqlCommand);
        } catch (Exception e) {
            System.err.println("Error appending to document label " + e);
        }

        try(CallableStatement statement = mySQLConnection.prepareCall(sqlCommand)) {
            boolean operation = statement.execute();

            System.out.println(operation);
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
     * Constructs and returns the SQL string to call a stored procedure with the specified procedure name and parameters for creating a test.
     * Each parameter is concatenated with the corresponding test parameter value.
     *
     * @param procedure The name of the stored procedure to call.
     * @return The SQL string to call the stored procedure for creating a test.
     */
    private String getSQLCommandCreateTest(String procedure) {
        return "{CALL " + procedure + "(" +
                "\"Experiencia " + TEST_NUMBER + "\", " + NUMBER_OF_RATS + ", " + LIMIT_MOUSE_PER_ROOM + ", " + TIME_WITHOUT_MOVEMENT
                + ", " + IDEAL_TEMP + ", " + MAX_TEMP_DEVIATION + ", \"" + EMAIL + "\")}";
    }

    /**
     * Constructs and returns the SQL string to call a stored procedure with the specified procedure name and test number.
     *
     * @param procedure The name of the stored procedure to call.
     * @return The SQL string to call the stored procedure.
     */
    private String setTestStatus(String procedure, boolean finish) {
        if(finish) return "{CALL " + procedure + "()}";
        else return "{CALL " + procedure + "(" + TEST_NUMBER + ")}";
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
            if(documentLabel != null) documentLabel.append(s + "\n");
            else System.out.println(s);
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
