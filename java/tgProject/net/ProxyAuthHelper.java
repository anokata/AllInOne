import java.io.InputStream;
import java.lang.reflect.Method;
import java.net.Authenticator;
import java.net.PasswordAuthentication;
import java.net.URL;
import java.net.URLConnection;
import java.util.Scanner;

public class ProxyAuthHelper {

    public static void main(String[] args) throws Exception {
        String tmp = System.getProperty("http.proxyUser", System.getProperty("https.proxyUser"));
        if (tmp == null) {
            System.out.println("Proxy username: ");
            tmp = new Scanner(System.in).nextLine();
        }
        final String userName = tmp;

        tmp = System.getProperty("http.proxyPassword", System.getProperty("https.proxyPassword"));
        if (tmp == null) {
            System.out.println("Proxy password: ");
            tmp = new Scanner(System.in).nextLine();
        }
        final char[] password = tmp.toCharArray();

        Authenticator.setDefault(new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                System.out.println("\n--------------\nProxy auth: " + userName);
                return new PasswordAuthentication (userName, password);
            }

         });

        Class<?> clazz = Class.forName(args[0]);
        Method method = clazz.getMethod("main", String[].class);
        String[] newArgs = new String[args.length - 1];
        System.arraycopy(args, 1, newArgs, 0, newArgs.length);
        method.invoke(null, new Object[]{newArgs});
    }

}