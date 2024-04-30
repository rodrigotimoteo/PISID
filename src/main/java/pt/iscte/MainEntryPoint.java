package pt.iscte;

import pt.iscte.mqtt.ReadFromMQTTWriteToMongo;
import pt.iscte.mqtt.SendToMQTT;
import pt.iscte.mysql.WriteToSQL;

import javax.swing.*;

public class MainEntryPoint {

    /**
     * JTextArea for displaying document labels.
     */
    static JTextArea documentLabel = new JTextArea("\n");

    public static void main(String[] args) throws InterruptedException {
        if(args.length == 0) System.exit(0);
        else {
            switch (args[0]) {
                case "SendToMongo" -> {
                    documentLabel = CommonUtilities.createWindow("Cloud to Mongo");
                    ReadFromMQTTWriteToMongo.injectDocumentLabel(documentLabel);

                    new ReadFromMQTTWriteToMongo().connectMongo();
                    new ReadFromMQTTWriteToMongo().connectCloud();
                }
                case "SendToMQTT" -> {
                    documentLabel = CommonUtilities.createWindow("Send to MQTT");
                    SendToMQTT.initFile();
                    SendToMQTT.hasStoredId();
                    SendToMQTT.injectDocumentLabel(documentLabel);

                    new SendToMQTT().connectMazeSettings();
                    new SendToMQTT().connectMongo();
                    new SendToMQTT().connectCloud();
                }
                case "SendToSQL" -> {
                    documentLabel = CommonUtilities.createWindow("Data Bridge");
                    SendToMQTT.injectDocumentLabel(documentLabel);

                    new WriteToSQL().connectDatabase();
                    new WriteToSQL().connectCloud();
                }
//                case "ALL" -> {
//                    ReadFromMQTTWriteToMongo.injectDocumentLabel(documentLabel);
//
//                    new ReadFromMQTTWriteToMongo().connectMongo();
//                    new ReadFromMQTTWriteToMongo().connectCloud();
//
//                    Thread.sleep(2000);
//
//                    JTextArea documentLabelExtra1 = new JTextArea("\n");
//                    SendToMQTT.initFile();
//                    SendToMQTT.hasStoredId();
//                    SendToMQTT.injectDocumentLabel(documentLabelExtra1);
//
//                    new SendToMQTT().connectMazeSettings();
//                    new SendToMQTT().connectMongo();
//                    new SendToMQTT().connectCloud();
//
//                    Thread.sleep(5000);
//
//                    JTextArea documentLabelExtra2 = new JTextArea("\n");
//                    SendToMQTT.injectDocumentLabel(documentLabelExtra2);
//
//                    new WriteToSQL().connectDatabase();
//                    new WriteToSQL().connectCloud();
//                }
            }
        }
    }


}
