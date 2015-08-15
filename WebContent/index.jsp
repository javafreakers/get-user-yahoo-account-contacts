<html>
<head>
<title>Import Yahoo Contacts</title>
</head>
<body>
<%
String YAHOO_API_Key = "your App consumer key--";
String CALLBACK_URI = "http://localhost:8080/Yahoo_Contact_Import/yahooContacts.jsp";
String domainName = "http://localhost:8080";
String openIdAuthUrl = "https://open.login.yahooapis.com/openid/op/auth?"+
        "openid.claimed_id=http://specs.openid.net/auth/2.0/identifier_select"+
        "&openid.identity=http://specs.openid.net/auth/2.0/identifier_select"+
        "&openid.mode=checkid_setup"+
        "&openid.ns=http://specs.openid.net/auth/2.0"+
        "&openid.realm="+domainName+
        "&openid.return_to="+CALLBACK_URI+
        "&openid.ns.oauth=http://specs.openid.net/extensions/oauth/1.0"+
        "&openid.oauth.consumer="+YAHOO_API_Key;
%>
<a href="<%=openIdAuthUrl %>">Import Yahoo Contacts</a>
</body>
</html>