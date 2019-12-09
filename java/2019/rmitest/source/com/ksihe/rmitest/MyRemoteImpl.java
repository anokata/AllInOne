package com.ksihe.rmitest;
import com.ksihe.rmitest.MyRemote;

class MyRemoteImpl implements MyRemote {
    public long doSome(int p) {
        return Math.round(Math.pow(2, p*3 + 1));
    }
}
