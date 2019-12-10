import java.awt.event.*;
import javax.swing.*;
import java.awt.*;
import java.util.*;
import java.io.*;
import java.net.*;
import java.rmi.*;

class ServiceBrowser {
    JPanel mainPanel;
    JComboBox serviceList;
    ServiceServer server;

    public void buildGUI() {
        JFrame frame = new JFrame("RMI Viewer");
        mainPanel = new JPanel();
    }

    public static void main(String[] args) {
        ServiceBrowser app = new ServiceBrowser();
    }

    ServiceBrowser () {
        System.out.println("Created ServiceBrowser");
    }
}

