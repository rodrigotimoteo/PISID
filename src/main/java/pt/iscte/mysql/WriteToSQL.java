package pt.iscte.mysql;
//(c) ISCTE-IUL, Pedro Ramos, 2022

//import org.bson.Document;
//import org.bson.*;
//import org.bson.conversions.*;

//import org.json.JSONArray;
//import org.json.JSONObject;
//import org.json.JSONException;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.util.Properties;


public class WriteToSQL {
    static JTextArea documentLabel = new JTextArea("\n");
    static Connection connTo;
    static String sql_database_connection_to = "";
    static String sql_database_password_to= "";
    static String sql_database_user_to= "";
    static String  sql_table_to= "";


    private static void createWindow() {
        JFrame frame = new JFrame("Data Bridge");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        JLabel textLabel = new JLabel("Data : ",SwingConstants.CENTER);
        textLabel.setPreferredSize(new Dimension(600, 30));
        JScrollPane scroll = new JScrollPane (documentLabel,JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);
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

    public  static void main(String[] args) {
        createWindow();
        try {
            Properties p = new Properties();
            p.load(new FileInputStream("pt/iscte/mysql/WriteMySQL.ini"));
            sql_table_to= p.getProperty("sql_table_to");
            sql_database_connection_to = p.getProperty("sql_database_connection_to");
            sql_database_password_to = p.getProperty("sql_database_password_to");
            sql_database_user_to= p.getProperty("sql_database_user_to");
        } catch (Exception e) {
            System.out.println("Error reading WriteMysql.ini file " + e);
            JOptionPane.showMessageDialog(null, "The WriteMysql ini file wasn't found.", "Data Migration", JOptionPane.ERROR_MESSAGE);
        }
        new WriteToSQL().connectDatabase_to();
        new WriteToSQL().ReadData();
    }

    public void connectDatabase_to() {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            connTo =  DriverManager.getConnection(sql_database_connection_to,sql_database_user_to,sql_database_password_to);
            documentLabel.append("SQl Connection:"+sql_database_connection_to+"\n");
            documentLabel.append("Connection To MariaDB Destination " + sql_database_connection_to + " Succeeded"+"\n");
        } catch (Exception e){System.out.println("Mysql Server Destination down, unable to make the connection. "+e);}
    }


    public void ReadData() {
        String doc;
        int i = 0;
        while (i < 100) {
            doc = "{Name:\"Nome_"+i+"\", Location:\"Portugal\", id:"+i+"}";
            //WriteToMySQL(com.mongodb.util.JSON.serialize(doc));
            WriteToMySQL(doc);
            i++;
        }
    }

    public void WriteToMySQL (String c){
        String SQLCommand = getSqlCommand(c);
        //System.out.println(SqlCommando);

        try {
            documentLabel.append(SQLCommand + "\n");
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            Statement s = connTo.createStatement();
            int result = s.executeUpdate(SQLCommand);

            System.out.println(SQLCommand);

            s.close();
        } catch (Exception e){System.out.println("Error Inserting in the database . " + e); System.out.println(SQLCommand);}
    }

    private static String getSqlCommand(String convertedJSON) {
        StringBuilder fields = new StringBuilder();
        StringBuilder values = new StringBuilder();
        String SqlCommand;
        String[] splitArray = convertedJSON.split(",");

        for (int i = 0; i < splitArray.length; i++) {
            String[] splitArray2 = splitArray[i].split(":");
            if (i == 0) fields = new StringBuilder(splitArray2[0]);
            else fields.append(", ").append(splitArray2[0]);
            if (i == 0) values = new StringBuilder(splitArray2[1]);
            else values.append(", ").append(splitArray2[1]);
        }

        fields = new StringBuilder(fields.toString().replace("\"", ""));
        SqlCommand = "Insert into " + sql_table_to + " (" + fields.substring(1, fields.length()) + ") values (" +
                values.substring(0, values.length() - 1) + ");";
        return SqlCommand;
    }


}