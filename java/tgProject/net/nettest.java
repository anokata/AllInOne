import java.net.*;
import java.io.*;

class nettest {
	public static void main(String args[]) {
		try
        {
			int r;
			byte buf[] = new byte[64*1024];
			
			final String authUser = "tikhomirov";
			final String authPassword = "LBjXVCc6nWd7";

System.setProperty("http.proxyHost", "hostAddress");
System.setProperty("http.proxyPort", "portNumber");
System.setProperty("http.proxyUser", authUser);
System.setProperty("http.proxyPassword", authPassword);

Authenticator.setDefault(
  new Authenticator() {
    public PasswordAuthentication getPasswordAuthentication() {
      return new PasswordAuthentication(authUser, authPassword.toCharArray());
    }
  }
);
			
			
			String host = "www.ya.ru";
			int port = 80;
			String header = "GET http://ya.ru HTTP/1.1\nHost: www.ya.ru\nUser-Agent: HTTPClient";
			Socket s = new Socket(host, port);
			s.getOutputStream().write(header.getBytes());
			InputStream is = s.getInputStream();
			r = 1;
				while(r > 0)
				{
					r = is.read(buf);
					if(r > 0)
						System.out.print(buf);
				}
			s.close();
			}
			catch(Exception e)
			{e.printStackTrace();}
	}
}