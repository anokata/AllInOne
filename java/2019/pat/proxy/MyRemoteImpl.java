import java.rmi.*;
import java.rmi.server.*;

class MyRemoteImpl extends UnicastRemoteObject implements MyRemote {
    private static final long servialVersionUID = 1L;
    public String say() throws RemoteException {
        return "Server says Hi";
    }
    
    public static void main(String[] args) {
        try {
            MyRemote service = new MyRemoteImpl();
            Naming.rebind("RemoteHello", service);
        } catch (Exception ex) { ex.printStackTrace(); }
    }
    
    MyRemoteImpl() throws RemoteException {}
}
