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
        JLabel textLabel = new JLabel("Data to send do broker: ",SwingConstants.CENTER);
        JButton b1 = new JButton("Send Data");
        frame.getContentPane().add(textLabel, BorderLayout.PAGE_START);
        frame.getContentPane().add(documentLabel, BorderLayout.CENTER);
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
            mongoProp.load(new FileInputStream("src/main/java/pt/iscte/mqtt/SendCloud.ini"));

            Properties mqttProp = new Properties();
            mqttProp.load(new FileInputStream("src/main/java/pt/iscte/mqtt/SendCloud.ini"));

            mongo_address   = mongoProp.getProperty("mongo_address");
            mongo_user      = mongoProp.getProperty("mongo_user");
            mongo_password  = mongoProp.getProperty("mongo_password");
            mongo_replica   = mongoProp.getProperty("mongo_replica");
            cloud_server    = mqttProp.getProperty("cloud_server");
            cloud_topic_temp= mqttProp.getProperty("cloud_topic_temp");
            cloud_topic_maze= mqttProp.getProperty("cloud_topic_maze");
            mongo_host      = mongoProp.getProperty("mongo_host");
            mongo_database  = mongoProp.getProperty("mongo_database");
            mongo_auth      = mongoProp.getProperty("mongo_authentication");
            mongo_collection= mongoProp.getProperty("mongo_general_collection");
            mongo_temp1_collection = mongoProp.getProperty("mongo_temp1_collection");
            mongo_temp2_collection = mongoProp.getProperty("mongo_temp2_collection");
            mongo_door_collection  = mongoProp.getProperty("mongo_door_collection");
        } catch (Exception e) {
            System.out.println("Error reading SendCloud.ini file " + e);
            JOptionPane.showMessageDialog(null, "The SendCloud.ini file wasn't found.", "Send Cloud", JOptionPane.ERROR_MESSAGE);
        }

        new SendToMQTT().connectCloud();
        new SendToMQTT().connectMongo();
    }

    public void connectCloud() {
        try {
            mqttClientTemp = new MqttClient(cloud_server, "SimulateSensor" + cloud_topic_temp);
            mqttClientTemp.connect();
            mqttClientTemp.setCallback(this);
            mqttClientTemp.subscribe(cloud_topic_temp);

            mqttClientMaze = new MqttClient(cloud_server, "SimulateSensor" + cloud_topic_maze);
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
    }

    @Override
    public void connectionLost(Throwable cause) {    }

    @Override
    public void deliveryComplete(IMqttDeliveryToken token) { }

    @Override
    public void messageArrived(String topic, MqttMessage message){ }

}