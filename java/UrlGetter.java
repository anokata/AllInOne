import java.net.*;
import java.io.*;
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

class UrlGetter {
    static String forecastUrl = 
        "http://www.yr.no/place/Russia/Yaroslavl/Rybinsk/forecast_hour_by_hour.xml";
    
    public static InputStream getWeatherStream(String url)
            throws IOException, MalformedURLException {
        URL weatherXMLURL = new URL(url);
        URLConnection yc = weatherXMLURL.openConnection();
        return yc.getInputStream();
    }

    public static Node getOneNodeForXPath(Document doc, String query)
            throws XPathExpressionException {
        XPathFactory pathFactory = XPathFactory.newInstance();
        XPath xpath = pathFactory.newXPath();
        XPathExpression expr = xpath.compile(query);
        NodeList nodes = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);
        return nodes.item(0);
    }

    public static void main(String[] args) 
            throws Exception {

        Document doc = loadXMLFromStream(getWeatherStream(forecastUrl));
        //NodeList items = doc.getDocumentElement().getChildNodes();
        Node node = getOneNodeForXPath(doc, "//time[1]/windDirection");
        System.out.println("" + node.getAttributes().getNamedItem("deg"));
        System.out.println("current pressure: " + getCurrentPressure(doc));
    }

    public static String getFirstWeatherParam(Document doc, String tag, String param)
            throws XPathExpressionException {
        return getOneNodeForXPath(doc, "//time[1]/" + tag)
                    .getAttributes().getNamedItem(param)
                    .getNodeValue();
    }

    public static String getCurrentPressure(Document doc) 
            throws XPathExpressionException {
        return getFirstWeatherParam(doc, "pressure", "value");
    }

    public static Document loadXMLFromStream(InputStream is) throws Exception {
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        DocumentBuilder builder = factory.newDocumentBuilder();
        return builder.parse(is);
    }
}
