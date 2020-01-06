import java.rmi.*;

interface MyRemote extends Remote {
    public String say() throws RemoteException;
}
