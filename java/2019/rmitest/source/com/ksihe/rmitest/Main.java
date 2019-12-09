package com.ksihe.rmitest;
import java.util.*;
import java.io.*;
import java.net.*;
import com.ksihe.rmitest.*;
import com.ksihe.rmitest.MyRemote;

class Main {
    public static void main(String[] args) {
        Main app = new Main();
    }

    Main () {
        System.out.println("Created Main");
        MyRemote m = new MyRemoteImpl();
    }
}

