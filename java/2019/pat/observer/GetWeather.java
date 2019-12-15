import java.util.*;
import java.io.*;
import java.net.*;

// https://www.weatherbit.io/api
class GetWeather {
    final String APIKEY = "68ef485b8e294c84837d02b96b8f6763";
    //final String URL = "https://api.weatherbit.io/v2.0/current?lat=58&lon=38&key=68ef485b8e294c84837d02b96b8f6763";
    final String URL = "api.weatherbit.io/v2.0/current";

	private static void sendGET(String url) throws IOException {
		URL obj = new URL(url);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		con.setRequestMethod("GET");
		//con.setRequestProperty("User-Agent", USER_AGENT);
		con.setRequestProperty("lat", "58");
		con.setRequestProperty("lon", "38");
		con.setRequestProperty("key", "68ef485b8e294c84837d02b96b8f6763");
		System.out.println(con);
		int responseCode = con.getResponseCode();
		System.out.println("GET Response Code :: " + responseCode);
		if (responseCode == HttpURLConnection.HTTP_OK) { // success
			BufferedReader in = new BufferedReader(new InputStreamReader(
					con.getInputStream()));
			String inputLine;
			StringBuffer response = new StringBuffer();

			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();

			// print result
			System.out.println(response.toString());
		} else {
			System.out.println("GET request not worked");
		}

	}

    public static void main(String[] args) {
        GetWeather app = new GetWeather();
    }

    GetWeather () {
        System.out.println("Created GetWeather");
        try {
            sendGET(URL);
        } catch (Exception ex) { ex.printStackTrace(); }
    }
}

