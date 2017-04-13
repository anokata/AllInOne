import java.net.*;
import java.io.*;
import java.util.*;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

/* 
 * Gets forecast list map.
 */
class ForecastObtainer {
    private static final String forecastUrl = 
        "http://www.yr.no/place/Russia/Yaroslavl/Rybinsk/forecast_hour_by_hour.xml";

    public static List<? extends Map<String, String>> getForecast(String url)
            throws XPathExpressionException, 
                   IOException, 
                   SAXException,
                   ParserConfigurationException {
        return getForecastFromDoc(loadXMLFromStream(
                    getWeatherStream(forecastUrl)));
    }

    public static void main(String[] args) 
            throws Exception {
        System.out.println(getForecast(forecastUrl));
    }
    
    //TODO: make method current weather in words 
    //and how it change in near time(up or down
    //temp, rain? wind raise?)
    private static List<? extends Map<String, String>> getForecastFromDoc(Document doc)
            throws XPathExpressionException {
        //TODO: extract
        //TODO: make get one and use it for now weather and this loop simplification
        Map<String, String> forecastDict = new HashMap<String, String>();
        forecastDict.put("windSpeed", "mps");
        forecastDict.put("temperature", "value");
        forecastDict.put("pressure", "value");

        List<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
        NodeList nodes = getNodesForXPath(doc, "//time"); // FIXME sorted?
        for (int i = 0; i < nodes.getLength(); i++) {
            Node node = nodes.item(i);
            HashMap<String, String> data = new HashMap<>();
            for(Map.Entry<String, String> e : forecastDict.entrySet()) {
                String key = e.getKey();
                String attribute = e.getValue();
                String value = getOneNodeForXPath(node, key)
                    .getAttributes().getNamedItem(attribute)
                    .getNodeValue();
                data.put(key, value);
            }
            list.add(data);
        }
        return list;
    }

    public static Document loadXMLFromStream(InputStream is) 
        throws SAXException, IOException, ParserConfigurationException {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        return builder.parse(is);
    }

    private static InputStream getWeatherStream(String url)
            throws IOException, MalformedURLException {
        URL weatherXMLURL = new URL(url);
        URLConnection yc = weatherXMLURL.openConnection();
        return yc.getInputStream();
    }

    private static Node getOneNodeForXPath(Object doc, String query)
            throws XPathExpressionException {
        return getNodesForXPath(doc, query).item(0);
    }
    
    private static NodeList getNodesForXPath(Object doc, String query)
            throws XPathExpressionException {
        XPathFactory pathFactory = XPathFactory.newInstance();
        XPath xpath = pathFactory.newXPath();
        XPathExpression expr = xpath.compile(query);
        NodeList nodes = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);
        return nodes;
    }

}
