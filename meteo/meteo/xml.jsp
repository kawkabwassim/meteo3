<%@ page import="java.net.URL"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom2.Document"%>
<%@ page import="org.jdom2.Element"%>
<%@ page import="org.jdom2.JDOMException"%>
<%@ page import="org.jdom2.input.SAXBuilder"%>
<%-- // Documentazione: http://www.jdom.org/docs/apidocs/index.html?org/jdom2/Element.html
<current>
<city id="2643743" name="London">
<coord lon="-0.13" lat="51.51"/>
<country>GB</country>
<sun rise="2017-01-30T07:40:36" set="2017-01-30T16:47:56"/>
</city>
<temperature value="280.15" min="278.15" max="281.15" unit="kelvin"/>
<humidity value="81" unit="%"/>
<pressure value="1012" unit="hPa"/>
<wind>
<speed value="4.6" name="Gentle Breeze"/>
<gusts/>
<direction value="90" code="E" name="East"/>
</wind>
<clouds value="90" name="overcast clouds"/>
<visibility value="10000"/>
<precipitation mode="no"/>
<weather number="701" value="mist" icon="50d"/>
<lastupdate value="2017-01-30T15:50:00"/>
</current>
 --%>
 <html>
 <head>
 <title>XML da URL</title>
 </head>
<%

SAXBuilder builder = new SAXBuilder();

URL xmlFile = new URL("http://samples.openweathermap.org/data/2.5/weather?q=treviso&mode=xml&appid=b1b15e88fa797225412429c1c50c122a1");

out.println("entro nel try");

try {

	Document document = (Document) builder.build(xmlFile); // Creo il documento
	Element rootNode = document.getRootElement(); //Recupero l'elemento del nodo root
	
	Element e = rootNode.getChild("city");
	out.println("Siamo nella citt� di: " + e.getAttribute("name").getValue());
	out.println("La velocit� del vento e': "+ rootNode.getChild("wind").getChild("speed").getAttribute("value").getValue());
	
	/* Esempio se devo leggere da una lista di nodi
	List list = rootNode.getChildren("city"); // Prendo la lista delle citt� 
	for (int i = 0; i < list.size(); i++) {
	   Element node = (Element) list.get(i);

	   System.out.println("First Name : " + node.getChildText("country"));
	   System.out.println("Last Name : " + node.getChildText("lastname"));
	   System.out.println("Nick Name : " + node.getChildText("nickname"));
	   System.out.println("Salary : " + node.getChildText("salary"));

	}*/

} catch (IOException io) {
	System.out.println(io.getMessage());
} catch (JDOMException jdomex) {
	System.out.println(jdomex.getMessage());
}

%>