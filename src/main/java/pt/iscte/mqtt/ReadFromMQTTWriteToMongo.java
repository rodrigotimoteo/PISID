package pt.iscte.mqtt;

import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import com.mongodb.*;
import org.bson.*;
import com.mongodb.util.JSON;

import java.util.*;
import java.io.*;
import javax.swing.*;
import java.awt.*;

public class ReadFromMQTTWriteToMongo implements MqttCallback {
    MqttClient mqttClientTemp;
    MqttClient mqttClientMaze;

    static MongoClient mongoClient;

    static DB db;

    static DBCollection temp_sensor_1;
    static DBCollection temp_sensor_2;
    static DBCollection door_sensor;
    static DBCollection mongoCol;

    static String mongo_user = "";
    static String mongo_password = "";
    static String mongo_address = "";
    static String cloud_server = "";
    static String cloud_topic_temp = "";
    static String cloud_topic_maze = "";
    static String mongo_host = "";
    static String mongo_replica = "";
    static String mongo_database = "";
    static String mongo_collection = "";
    static String mongo_temp1_collection = "";
    static String mongo_temp2_collection = "";
    static String mongo_door_collection = "";
    static String mongo_auth = "";
    static JTextArea documentLabel = new JTextArea("\n");


    private static void createWindow() {
        JFrame frame = new JFrame("Cloud to Mongo");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JLabel textLabel = new JLabel("Data from broker: ",SwingConstants.CENTER);
        textLabel.setPreferredSize(new Dimension(600, 30));
        JScrollPane scroll = new JScrollPane (documentLabel, JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
        scroll.setPreferredSize(new Dimension(600, 200));
        JButton b1 = new JButton("Stop the program");
        frame.getContentPane().add(textLabel, BorderLayout.PAGE_START);
        frame.getContentPane().add(scroll, BorderLayout.CENTER);
        frame.getContentPane().add(b1, BorderLayout.PAGE_END);
        frame.setLocationRelativeTo(null);
        frame.pack();
        frame.setVisible(true);
        b1.addActionListener(evt -> System.exit(0));
    }

    public static void main(String[] args) {
        createWindow();
        try {
            Properties p = new Properties();
            p.load(new FileInputStream("src/main/java/pt/iscte/mqtt/CloudtoMongo.ini"));
            mongo_address   = p.getProperty("mongo_address");
            mongo_user      = p.getProperty("mongo_user");
            mongo_password  = p.getProperty("mongo_password");
            mongo_replica   = p.getProperty("mongo_replica");
            cloud_server    = p.getProperty("cloud_server");
            cloud_topic_temp= p.getProperty("cloud_topic_temp");
            cloud_topic_maze= p.getProperty("cloud_topic_maze");
            mongo_host      = p.getProperty("mongo_host");
            mongo_database  = p.getProperty("mongo_database");
            mongo_auth      = p.getProperty("mongo_authentication");
            mongo_collection= p.getProperty("mongo_general_collection");
            mongo_temp1_collection = p.getProperty("mongo_temp1_collection");
            mongo_temp2_collection = p.getProperty("mongo_temp2_collection");
            mongo_door_collection  = p.getProperty("mongo_door_collection");
        } catch (Exception e) {
            System.out.println("Error reading CloudToMongo.ini file " + e);
            JOptionPane.showMessageDialog(null, "The CloudToMongo.ini file wasn't found.",
                    "CloudToMongo", JOptionPane.ERROR_MESSAGE);
        }
        new ReadFromMQTTWriteToMongo().connectCloud();
        new ReadFromMQTTWriteToMongo().connectMongo();
    }

    public void connectCloud() {
        int i;
        try {
            i = new Random().nextInt(100000);
            mqttClientTemp = new MqttClient(cloud_server, "CloudToMongo Temp" + i + "_" + cloud_topic_temp);
            mqttClientTemp.connect();
            mqttClientTemp.setCallback(this);
            mqttClientTemp.subscribe(cloud_topic_temp);

            mqttClientMaze = new MqttClient(cloud_server, "CloudToMongo Maze" + i + "_" + cloud_topic_maze);
            mqttClientMaze.connect();
            mqttClientMaze.setCallback(this);
            mqttClientMaze.subscribe(cloud_topic_maze);
        } catch (MqttException e) {
            e.printStackTrace();
        }
    }

    public void connectMongo() {
        String mongoURI;
        //mongoURI = "mongodb://";
        mongoURI = "";
        if (mongo_auth.equals("true")) mongoURI = mongoURI + mongo_user + ":" + mongo_password + "@";

        mongoURI = mongoURI + mongo_address;

        if (!mongo_replica.equals("false"))
            if (mongo_auth.equals("true")) mongoURI = mongoURI + "/?replicaSet=" + mongo_replica+"&authSource=admin";
            else mongoURI = mongoURI + "/?replicaSet=" + mongo_replica;
        else if (mongo_auth.equals("true")) mongoURI = mongoURI  + "/?authSource=admin";

        mongoClient = new MongoClient(new MongoClientURI(mongoURI));
        db = mongoClient.getDB(mongo_database);


        temp_sensor_1 = db.getCollection(mongo_temp1_collection);
        temp_sensor_2 = db.getCollection(mongo_temp2_collection);
        door_sensor   = db.getCollection(mongo_door_collection);
        System.out.println(mongo_temp1_collection);
        mongoCol = db.getCollection(mongo_collection);
    }

    @Override
    public void messageArrived(String topic, MqttMessage c) throws Exception {
        try {
            DBObject document_json;
            document_json = (DBObject) JSON.parse(c.toString());
            if(document_json.containsField("OriginRoom"))
                treatDoorSensorMessage(document_json);
            else
                treatTempSensorMessage(document_json, (Integer) document_json.get("Sensor"));

            documentLabel.append(c + "\n");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void treatTempSensorMessage(DBObject message, int sensor) {
        if(sensor == 1) {
            temp_sensor_1.insert(message);
        } else { //Currently the sensor 2 takes wrong inputs (invalid inputs from mqtt)
            temp_sensor_2.insert(message);
        }
    }

    private void treatDoorSensorMessage(DBObject message) {
        door_sensor.insert(message);
    }

    @Override
    public void connectionLost(Throwable cause) {

    }

    @Override
    public void deliveryComplete(IMqttDeliveryToken token) {

    }
}