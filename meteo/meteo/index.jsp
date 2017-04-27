 
<%--
Questo � un commento
--%>
<%
String nome="fabio";
// Imposta un valore nella sessione (chiave, valore)
session.setAttribute("prova", "1");
// legge il valore dalla sessione
out.println(session.getAttribute("prova"));
%>
<html>
<head>

</head>
<body>
Ciao <% out.print(nome); %>!
Ciao <%= nome %>!
Il dato passato alla pagina �: <% out.println(request.getParameter("dato")); %>
<ol>
<li>Prova</li>
<%
 for (int i=0; i<10; i++) {
	 out.println("<li>"+i+"</li>");
 }
%>
</ol>
<form method="post">
<input type="text" name="dato">
<input type="text" name="nome">
<input type="submit">
</form>
Accesso al database:
<%

	Connection cn;
	Statement st;
	ResultSet rs;
	String sql;
	// ________________________________connessione
	try {
		Class.forName("com.mysql.jdbc.Driver");
	} catch (ClassNotFoundException e) {
		out.println("ClassNotFoundException: ");
		//System.err.println(e.getMessage());
	} // fine try-catch

	// Creo la connessione al database
	cn = DriverManager.getConnection("jdbc:mysql://localhost:3306/atleti?user=root&password=");
	// peer � il nome del database

	sql = "SELECT * FROM citta;";
	// ________________________________query
	try {
		st = cn.createStatement(); // creo sempre uno statement sulla
									// connessione
		rs = st.executeQuery(sql); // faccio la query su uno statement
		while (rs.next() == true) {
			out.println(rs.getString("id") + "\t" + rs.getString("Nome"));
		}
	} catch (SQLException e) {
		out.println("errore:" + e.getMessage());
	} // fine try-catch
	cn.close(); // chiusura connessione

%>

</body>
</html>