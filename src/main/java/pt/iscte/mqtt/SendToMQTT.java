package pt.iscte.mqtt;

import com.mongodb.*;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.util.*;

import java.io.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class SendToMQTT implements MqttCallback {
    static MqttClient mqttClientTemp;
    static MqttClient mqttClientMaze;

    static MongoClient mongoClient;

    static DB db;

    static DBCollection temp_sensor_1;
    static DBCollection temp_sensor_2;
    static DBCollection door_sensor;

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

    public void publishSensor(String sensorData) {
        try {
            System.out.println("Hi");

            MqttMessage mqttMessage = new MqttMessage();
            mqttMessage.setPayload(sensorData.getBytes());

            //Check if message is sensor data or not if()
            treatTempSensorMessage(mqttMessage);
            treatDoorSensorMessage(mqttMessage);
        } catch (MqttException e) {
            e.printStackTrace();}
    }

    private void treatTempSensorMessage(MqttMessage mqttMessage) throws MqttException {
        mqttClientTemp.publish(cloud_topic_temp, mqttMessage);
    }

    private void treatDoorSensorMessage(MqttMessage mqttMessage) throws MqttException {
        mqttClientMaze.publish(cloud_topic_maze, mqttMessage);
    }

    private static void createWindow() {
        JFrame frame = new JFrame("Send to Cloud");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JLabel textLabel = new JLabel("Data sent to broker: ", SwingConstants.CENTER);
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
            Properties mongoProp = new Properties();
            mongoProp.load(new FileInputStream("src/main/java/pt/iscte/mqtt/CloudToMongo.ini"));

            mongo_address   = mongoProp.getProperty("mongo_address");
            mongo_user      = mongoProp.getProperty("mongo_user");
            mongo_password  = mongoProp.getProperty("mongo_password");
            mongo_replica   = mongoProp.getProperty("mongo_replica");
            mongo_host      = mongoProp.getProperty("mongo_host");
            mongo_database  = mongoProp.getProperty("mongo_database");
            mongo_auth      = mongoProp.getProperty("mongo_authentication");
            mongo_collection= mongoProp.getProperty("mongo_general_collection");
            mongo_temp1_collection = mongoProp.getProperty("mongo_temp1_collection");
            mongo_temp2_collection = mongoProp.getProperty("mongo_temp2_collection");
            mongo_door_collection  = mongoProp.getProperty("mongo_door_collection");
        } catch (Exception e) {
            System.err.println("Error reading SendCloud.ini file " + e);
        }

        try {
            Properties mqttProp = new Properties();
            mqttProp.load(new FileInputStream("src/main/java/pt/iscte/mqtt/SendCloud.ini"));

            cloud_server    = mqttProp.getProperty("cloud_server");
            cloud_topic_temp= mqttProp.getProperty("cloud_topic_temp");
            cloud_topic_maze= mqttProp.getProperty("cloud_topic_maze");

        } catch (Exception e) {
            System.err.println("Error reading SendCloud.ini file " + e);
        }

        new SendToMQTT().connectCloud();
        new SendToMQTT().connectMongo();
    }

    public void connectCloud() {
        try {
            int i = new Random().nextInt(100000);
            mqttClientTemp = new MqttClient(cloud_server, "MongoToMQTT Temp" + i + "_" + cloud_topic_temp);
            mqttClientTemp.connect();
            mqttClientTemp.setCallback(this);
            mqttClientTemp.subscribe(cloud_topic_temp);

            mqttClientTemp = new MqttClient(cloud_server, "MongoToMQTT Maze" + i + "_" + cloud_topic_maze);
            mqttClientTemp.connect();
            mqttClientTemp.setCallback(this);
            mqttClientTemp.subscribe(cloud_topic_maze);
        } catch (MqttException e) {
            System.err.println("Error connecting to MQTT Server");
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

        ScheduledExecutorService executorService = Executors.newScheduledThreadPool(1);
        executorService.scheduleAtFixedRate(() -> {
//            System.out.println("Hi");
        }, 5000, 200, TimeUnit.MILLISECONDS);
    }

    @Override
    public void connectionLost(Throwable cause) {    }

    @Override
    public void deliveryComplete(IMqttDeliveryToken token) {
        System.out.println("MQTT Sent");
    }

    @Override
    public void messageArrived(String topic, MqttMessage message){ }

}