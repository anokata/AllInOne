package com.ksihe.rmitest;
import java.rmi.Remote;
import java.rmi.*;

interface MyRemote extends Remote {
    long doSome(int p) throws RemoteException;
}

