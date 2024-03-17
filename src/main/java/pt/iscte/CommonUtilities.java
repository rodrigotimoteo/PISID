package pt.iscte;

import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientURI;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.ini4j.InvalidFileFormatException;
import org.ini4j.Wini;

import javax.swing.*;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Random;

public class CommonUtilities {

    public static JTextArea createWindow(String title) {
        //Create JTextArea for displaying data
        JTextArea documentLabel = new JTextArea("\n");

        //Create JFrame and configure layout
        JFrame frame = new JFrame(title);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JLabel textLabel = new JLabel("Data from broker: ", SwingConstants.CENTER);
        textLabel.setPreferredSize(new Dimension(600, 30));
        JScrollPane scroll = new JScrollPane (documentLabel, JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        scroll.setPreferredSize(new Dimension(600, 200));
        JButton b1 = new JButton("Stop the program");

        //Add components to frame and configure ActionListener for the button
        frame.getContentPane().add(textLabel, BorderLayout.PAGE_START);
        frame.getContentPane().add(scroll, BorderLayout.CENTER);
        frame.getContentPane().add(b1, BorderLayout.PAGE_END);
        frame.setLocationRelativeTo(null);
        frame.pack();
        frame.setVisible(true);
        b1.addActionListener(evt -> System.exit(0));

        return documentLabel;
    }

    /**
     * Connects to the MQTT broker based on configuration from the INI file and initializes MQTT clients.
     *
     * @param client the MqttCallback instance for handling MQTT message events
     * @param section the section name in the INI file containing MQTT configuration
     * @return an array of MQTT clients for temperature and maze topics
     * @throws RuntimeException if an error occurs while connecting to the MQTT broker or reading the INI file
     */

    public static MqttClient[] connectCloud(MqttCallback client, String section) {
        try {
            MqttClient mqttClientTemp;
            MqttClient mqttClientMaze;

            Wini ini = new Wini(new File("src/main/java/pt/iscte/Configuration.ini"));

            int i = new Random().nextInt(100000);
            mqttClientTemp = new MqttClient(ini.get(section, "MQTTServer"), "CloudToMongo " + i + "_"
                    + ini.get(section, "MQTTTopicTemp"));
            mqttClientTemp.connect();
            mqttClientTemp.setCallback(client);
            mqttClientTemp.subscribe(ini.get(section, "MQTTTopicTemp"));

            mqttClientMaze = new MqttClient(ini.get(section, "MQTTServer"), "CloudToMongo " + i + "_"
                    + ini.get(section, "MQTTTopicMaze"));
            mqttClientMaze.connect();
            mqttClientMaze.setCallback(client);
            mqttClientMaze.subscribe(ini.get(section, "MQTTTopicMaze"));

            return new MqttClient[]{mqttClientTemp, mqttClientMaze};

        } catch (MqttException e) {
            System.err.println("Failed to Connect to the MQTT Broker");
            throw new RuntimeException("Failed to Connect to the MQTT Broker", e);

        } catch (InvalidFileFormatException e) {
            System.err.println("Invalid File - Not ini File");
            throw new RuntimeException("Invalid File - Not ini File", e);

        } catch (IOException e) {
            System.err.println("Failed to read Configuration.ini file");
            throw new RuntimeException("Failed to read Configuration.ini file", e);
        }
    }

    /**
     * Connects to the MongoDB server and initializes database collections based on configuration from the INI file.
     *
     * @return an array of MongoDB collections for temperature sensors 1 and 2, and door sensors
     * @throws RuntimeException if an error occurs while reading or parsing the INI file
     */
    public static DBCollection[] connectMongo() {
        try {
            Wini ini = new Wini(new File("src/main/java/pt/iscte/Configuration.ini"));

            String mongoURI = "";

            //Comment this line to use cloud mongo solution
            mongoURI = "mongodb://";

            if (ini.get("Mongo", "MongoAuthentication").equals("true"))
                mongoURI = mongoURI + ini.get("Mongo", "MongoUser") + ":" + ini.get("Mongo",
                        "MongoPassword") + "@";

            mongoURI = mongoURI + ini.get("Mongo", "MongoAddress");

            if (ini.get("Mongo", "MongoReplica").equals("true"))
                if (ini.get("Mongo", "MongoAuthentication").equals("true"))
                    mongoURI = mongoURI + "/?replicaSet=" + ini.get("Mongo", "MongoReplica") + "&authSource=admin";
                else
                    mongoURI = mongoURI + "/?replicaSet=" + ini.get("Mongo", "MongoReplica");
            else if (ini.get("Mongo", "MongoAuthentication").equals("true"))
                mongoURI = mongoURI  + "/?authSource=admin";

            MongoClient mongoClient = new MongoClient(new MongoClientURI(mongoURI));

            DB db = mongoClient.getDB(ini.get("Mongo", "MongoDatabase"));

            DBCollection tempSensor1 = db.getCollection(ini.get("Mongo", "MongoTemp1Collection"));
            DBCollection tempSensor2 = db.getCollection(ini.get("Mongo", "MongoTemp2Collection"));
            DBCollection doorSensor = db.getCollection(ini.get("Mongo", "MongoDoorCollection"));

            return new DBCollection[]{tempSensor1, tempSensor2, doorSensor};

        } catch (InvalidFileFormatException e) {
            System.err.println("Invalid File - Not ini File");
            throw new RuntimeException("Invalid File - Not ini File", e);

        } catch (IOException e) {
            System.err.println("Failed to read Configuration.ini file");
            throw new RuntimeException("Failed to read Configuration.ini file", e);
        }
    }

    /**
     * Retrieves a configuration option from the specified section in the Configuration.ini file.
     *
     * @param section the section name in the INI file
     * @param option the option name in the specified section
     * @return the value of the configuration option
     * @throws RuntimeException if an error occurs while reading or parsing the INI file
     */
    public static String getConfig(String section, String option) {
        try {
            Wini ini = new Wini(new File("src/main/java/pt/iscte/Configuration.ini"));

            return ini.get(section, option);

        } catch (InvalidFileFormatException e) {
            System.err.println("Invalid File - Not ini File");
            throw new RuntimeException("Invalid File - Not ini File", e);

        } catch (IOException e) {
            System.err.println("Failed to read Configuration.ini file");
            throw new RuntimeException("Failed to read Configuration.ini file", e);
        }
    }

    /**
     * Establishes a connection to the MySQL database using configuration settings from an INI file.
     *
     * @return a Connection object representing the established database connection, or null if the connection fails
     */
    public static Connection connectDatabase() {
        try {
            Wini ini = new Wini(new File("src/main/java/pt/iscte/Configuration.ini"));

            String sqlDatabaseConnection = ini.get("MySQL", "sqlDatabaseConnection");
            String sqlDatabaseUser = ini.get("MySQL", "sqlDatabaseUser");
            String sqlDatabasePassword = ini.get("MySQL", "sqlDatabasePassword");

            Class.forName("org.mariadb.jdbc.Driver");
            return  DriverManager.getConnection(sqlDatabaseConnection, sqlDatabaseUser, sqlDatabasePassword);
        } catch (Exception e){
            System.err.println("MYSQL Server Destination down, unable to make the connection. " + e);
        }

        return null;
    }

}
