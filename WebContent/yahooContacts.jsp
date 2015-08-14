<%@page import="org.json.XML"%>
<%@page import="org.scribe.model.Verb"%>
<%@page import="org.scribe.builder.ServiceBuilder"%>
<%@page import="org.json.JSONArray"%>
<%@page import="net.sf.json.JSON"%>
<%@page import="net.sf.json.xml.XMLSerializer"%>
<%@page import="org.scribe.model.Response"%>
<%@page import="org.scribe.model.OAuthRequest"%>
<%@page import="org.scribe.model.Token"%>
<%@page import="org.scribe.builder.api.YahooApi"%>
<%@page import="org.scribe.oauth.OAuthService"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="org.apache.commons.httpclient.methods.PostMethod"%>
<%@page import="org.apache.commons.httpclient.HttpClient"%>
<%@page import="org.apache.commons.httpclient.NameValuePair"%>
<%
String YAHOO_API_Key = "dj0yJmk9VmQxQjBNblJjdlY2JmQ9WVdrOWRuVXlSbWswTXpZbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD00Ng--";
String CALLBACK_URI = "http://localhost:8080/Yahoo_Contact_Import/yahooContacts.jsp";
String domainName = "http://localhost:8080";
String YAHOO_API_SECRET = "6cc1455edbb2005aa3488bee822b7074d8ba0b41";
%>
<%
    try {
        if(request.getParameter("openid.oauth.request_token") !=null){
    NameValuePair[] data = {
                    new NameValuePair("oauth_consumer_key",YAHOO_API_Key),
                    new NameValuePair("oauth_signature_method",
                            "PLAINTEXT"),
                    new NameValuePair("oauth_version", "1.0"),
                    new NameValuePair("oauth_verifier", "null"),
                    new NameValuePair("oauth_timestamp",
                            System.currentTimeMillis()+""),
                    new NameValuePair("oauth_nonce", "8B9SpF"),
                    new NameValuePair(
                            "oauth_token",
                            request.getParameter("openid.oauth.request_token")),
                    new NameValuePair("grant_type",
                            "authorization_code"),
                    new NameValuePair("oauth_signature", YAHOO_API_SECRET+"&") };
        
            HttpClient client = new HttpClient();
            PostMethod post = new PostMethod(
                    "https://api.login.yahoo.com/oauth/v2/get_token");
            post.addRequestHeader("Host", "social.yahooapis.com");
             post.addRequestHeader("Content-Type",
                    "application/x-www-form-urlencoded"); 
            post.setRequestBody(data);
            client.executeMethod(post);
            BufferedReader b = new BufferedReader(
                    new InputStreamReader(
                            post.getResponseBodyAsStream()));
            StringBuilder sb = new StringBuilder();
            String str = null;
            while ((str = b.readLine()) != null) {
                sb.append(str);
            }
            JSONObject access_token = new JSONObject("{"+sb.toString().replaceAll("=", ":").replaceAll("&", ",")+"}");
             OAuthService service1 = new ServiceBuilder()
             .provider(YahooApi.class)
             .apiKey("dj0yJmk9VmQxQjBNblJjdlY2JmQ9WVdrOWRuVXlSbWswTXpZbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmeD00Ng--")
             .apiSecret("6cc1455edbb2005aa3488bee822b7074d8ba0b41")
             .build();
            String tk=access_token.getString("oauth_token").replaceAll("%3D", "=");
            Token token1 =new Token(tk,access_token.getString("oauth_token_secret"));
    
            OAuthRequest request1 = new OAuthRequest(Verb.GET,"https://social.yahooapis.com/v1/user/"+access_token.getString("xoauth_yahoo_guid")+"/contacts");
                    
            service1.signRequest(token1, request1);
                    request1.addHeader("realm", "yahooapis.com");
                    Response response1 = request1.send();
                    JSONObject jsonObject = XML.toJSONObject(response1.getBody().trim());
                    JSONArray jsonArray = jsonObject.getJSONObject("contacts").getJSONArray("contact");
                    for (int i = 0; i < jsonArray.length(); i++) {
                        if (jsonArray.getJSONObject(i).getJSONArray("fields")
                                .length() > 2 && jsonArray.getJSONObject(i).toString().contains("fields")) {
                            try {
                                Object object = jsonArray.getJSONObject(i)
                                        .getJSONArray("fields")
                                        .getJSONObject(0)
                                        .getJSONObject("value")
                                        .get("givenName");
                                String givenName = null;
                                if (object != null && !object.equals("null")) {
                                    givenName = object.toString();
                                    System.out.println("First Name :"+givenName);
                                }
                                Object object2 = jsonArray.getJSONObject(i)
                                        .getJSONArray("fields")
                                        .getJSONObject(0)
                                        .getJSONObject("value")
                                        .get("familyName");
                                System.out.println("Last Name :"+object2.toString());
                                System.out.println("Email Id :"+(String) jsonArray
                                .getJSONObject(i)
                                .getJSONArray("fields")
                                .getJSONObject(2).get("value"));
                                System.out.println();
                                System.out.println();
                                System.out.println(">>>");
                            } catch (Exception exception) {
                            }
                        }

                    }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
