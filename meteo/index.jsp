<%@ page import="java.net.URL"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom2.Document"%>

<%@ page import="org.jdom2.JDOMException"%>
<%@ page import="org.jdom2.input.SAXBuilder"%>

<%@ page import="org.jdom2.filter.ElementFilter"%>


<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.SQLException"%>

<%
	class Previsioni{
		
		Element element;
		
		public Previsioni(Element element){
			this.element = element;
		}
		
		public String toString(){
			//return "<p>Temperatura: " + element.getChild("temperature").getAttribute("value").getValue() + "</p>";
            return "Ciao";
		}
   
		public String getTemperature(){
			return "<p>Temperatura: " + element.getChild("temperature").getAttribute("value").getValue() + "</p>";
			
		}
		
		public String getWind(){
			String riga = "<p>Direzione del vento: " + element.getChild("windDirection").getAttribute("deg").getValue() + " " + element.getChild("windDirection").getAttribute("name").getValue() + "</p>";
			riga += "<p>Velocita' del vento: " + element.getChild("windSpeed").getAttribute("mps").getValue() + " " +element.getChild("windSpeed").getAttribute("name").getValue() +"</p>";
			return riga;
		}
		
		public String getPressure(){
			String riga = "<p>Pressione: " + element.getChild("pressure").getAttribute("value").getValue() + " " + element.getChild("pressure").getAttribute("unit").getValue() + "</p>";
			return riga;
		}
	
	}
%>

<%
	//Get city
	
	String ciao = "";
	boolean haInsterito = false;
	int count = 0;
	
	ciao = request.getParameter("city");
	
	if(ciao != null){
		haInsterito = true;
		Connection cn;
		Statement st;
		ResultSet rs;
		String sql;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			out.println("ClassNotFoundException: ");
		}

		cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/atleti?user=root&password=");

		sql = "SELECT citta FROM citta WHERE citta='" + ciao + "'";
		
		try {
			st = cn.createStatement(); // creo sempre uno statement sulla
			rs = st.executeQuery(sql); // faccio la query su uno statement
			while (rs.next() == true) {
				count ++;
				out.println(rs.getString("id") + "\t" + rs.getString("Nome"));
			}
		} catch (SQLException e) {
			out.println("errore:" + e.getMessage());
		}
		cn.close();
	}
%>

<%
	//Get dati
	
	Previsioni[] previsioni = new Previsioni[9];
	
	/*
	for(int i = 0; i < 9; i++){
		previsioni[i] = new Previsioni(null);
	}
	*/
	
	String info = "";
	if(count > 0){
		SAXBuilder builder = new SAXBuilder();

		//api.openweathermap.org/data/2.5/forecast?q=London,us&mode=xml
		URL xmlFile = new URL("http://api.openweathermap.org/data/2.5/forecast?q=" + ciao + "&mode=xml&appid=772bb79a11f2fbd9668f0f7e54e722a1&lang=it");
		
		try {

			Document document = (Document) builder.build(xmlFile); // Creo il documento
			Element rootNode = document.getRootElement(); //Recupero l'elemento del nodo root
			
			//Element e = rootNode.getChild("location");
			
			System.out.println("Ciao!!!!!");
			
			List list = rootNode.getChild("forecast").getChildren("time");
			previsioni = new Previsioni[list.size()];
			
			/*
			ElementFilter filter = new ElementFilter("forecast");
						
			for(Element c : rootNode.getDescendants(filter)) {
				System.out.println("Ciaone");
			}
			*/
			
			for (int i =0; i< list.size(); i++){
				Element node = (Element) list.get(i);
				previsioni[i] = new Previsioni(node);
			}
			
			for(int i = 0; i < 3; i++){
				//System.out.println(rootNode.getChild("forecast").getChild("time").getChild("windSpeed").getAttribute("name").getValue());
				previsioni[i] = new Previsioni(rootNode.getChild("forecast").getChild("time"));
			}
			
			System.out.println("After for");
			
			/*
			info = rootNode.getChild("forecast").getChild("time").getChild("precipitation").getAttribute("unit").getValue();
			out.println(": " + rootNode.getChild("forecast").getChild("time").getChild("precipitation").getAttribute("unit").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("precipitation").getAttribute("value").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("precipitation").getAttribute("type").getValue());
			
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("windDirection").getAttribute("deg").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("windDirection").getAttribute("name").getValue());

			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("windSpeed").getAttribute("mps").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("windSpeed").getAttribute("name").getValue());
		
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("temperature").getAttribute("unit").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("temperature").getAttribute("value").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("temperature").getAttribute("min").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("temperature").getAttribute("max").getValue());

			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("pressure").getAttribute("unit").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("pressure").getAttribute("value").getValue());
	
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("humidity").getAttribute("value").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("humidity").getAttribute("unit").getValue());

			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("clouds").getAttribute("value").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("clouds").getAttribute("all").getValue());
			out.println(": " +rootNode.getChild("forecast").getChild("time").getChild("clouds").getAttribute("unit").getValue());
			*/
		} catch (IOException io) {
			System.out.println("Error 1");
			System.out.println(io.getMessage());
		} catch (JDOMException jdomex) {
			System.out.println("Error 2");
			System.out.println(jdomex.getMessage());
		}
		System.out.println("Fine");
	}
	
	
%>

<!DOCTYPE html>
<html>
<title>Info Meteo</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Lato">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Montserrat">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
body,h1,h2,h3,h4,h5,h6 {font-family: "Lato", sans-serif}
.w3-bar,h1,button {font-family: "Montserrat", sans-serif}
.fa-anchor,.fa-coffee {font-size:200px}
</style>
<body>

<!-- Navbar  <%@ page import="org.jdom2.Element"%> -->
<div class="w3-top">
  <div class="w3-bar w3-red w3-card-2 w3-left-align w3-large">
    <a class="w3-bar-item w3-button w3-hide-medium w3-hide-large w3-right w3-padding-large w3-hover-white w3-large w3-red" href="javascript:void(0);" onclick="myFunction()" title="Toggle Navigation Menu"><i class="fa fa-bars"></i></a>
    <a href="#" class="w3-bar-item w3-button w3-padding-large w3-white">Home</a>
  </div>

  <!-- Navbar on small screens -->
  <div id="navDemo" class="w3-bar-block w3-white w3-hide w3-hide-large w3-hide-medium w3-large">
  </div>
</div>

<!-- Header -->
<header class="w3-container w3-red w3-center" style="padding:128px 16px">
  <h1 class="w3-margin w3-jumbo">KNOW YOUR WEATHER</h1>
  <p class="w3-xlarge">by Demian & Wassim</p>
    
    <center>
		<form action="index.jsp" method="POST">
			<input name="city" class="w3-input" type="text" placeholder="Inserisci la citta'" style="width:30%">
			<input value="Search" type="submit" class="w3-button w3-black w3-padding-large w3-large w3-margin-top">
			<br>
			
		</form>
    </center>
</header>

<div class="w3-row-padding w3-padding-64 w3-container w3-center w3-text-grey" style="width: 70%; margin-left: auto; margin-right:auto;">   
    
    <div id="day1" class="w3-third w3-center">
        <div class="w3-card-4">
          <img src="Immagini/cloudyWeather.png" alt="Person">
            <div class="w3-container w3-center">
                <h3>Oggi</h3>
				
                <%				
				if(haInsterito){
					if(count < 1){
						out.println("Inserire una citta' corretta");
					} else {
						out.println(previsioni[0].getTemperature());
						out.println(previsioni[0].getWind());
						out.println(previsioni[0].getPressure());
					}
				}
			%>
			
            </div>
        </div>
    </div>
    
    <div id="day2" class="w3-third w3-center">
        <div class="w3-card-4">
          <img src="Immagini/variableWeather.png"alt="Person">
            <div class="w3-container w3-center">
                <h3>Domani</h3>
                
				<%				
				if(haInsterito){
					if(count < 1){
						out.println("Inserire una citta' corretta");
					} else {
						out.println(previsioni[3].getTemperature());
						out.println(previsioni[3].getWind());
						out.println(previsioni[3].getPressure());
					}
				}
			%>
				
            </div>
        </div>
    </div>
    
    <div id="day3" class="w3-third w3-center">
        <div class="w3-card-4">
          <img src="Immagini/sunnyWeather.png" alt="Person">
            <div class="w3-container w3-center">
                <h3>Dopo domani</h3>
                <%				
				if(haInsterito){
					if(count < 1){
						out.println("Inserire una citta' corretta");
					} else {
						out.println(previsioni[6].getTemperature());
						out.println(previsioni[6].getWind());
						out.println(previsioni[6].getPressure());
					}
				}
			%>
            </div>
        </div>
    </div>
            
  </div>
</div>

<!-- Footer -->
<footer class="w3-container w3-padding-64 w3-center w3-opacity">  
 <p>Powered by Oleksandr & Wassim</a></p>
</footer>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.0/jquery.min.js"></script>
<script>
    
    
    
</script>

</body>
</html>
