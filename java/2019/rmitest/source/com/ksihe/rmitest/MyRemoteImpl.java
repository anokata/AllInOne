package com.ksihe.rmitest;
import com.ksihe.rmitest.MyRemote;
import java.rmi.server.*;
import java.rmi.*;

class MyRemoteImpl extends UnicastRemoteObject implements MyRemote {

    public static void main(String[] args) {
        try {
            MyRemote service = new MyRemoteImpl();
            Naming.rebind("Remote Hello", service);
        } catch (Exception ex) { ex.printStackTrace(); }
    }

    public long doSome(int p) {
        return Math.round(Math.pow(2, p*3 + 1));
    }

    public MyRemoteImpl() throws RemoteException {}

}
