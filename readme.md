Salesforce code to generate oAuth Access and Refresh Tokens without another application.

Requires an AuthSettings custom object, where you put the URL of your salesforce instance. I.E. companyname.my.salesforce.com.

References:
https://www.salesforce.com/us/developer/docs/api_rest/Content/intro_understanding_web_server_oauth_flow.htm
https://help.salesforce.com/HTViewHelpDoc?id=remoteaccess_oauth_scopes.htm&language=en_US


When you setup the oAuth app, set the Callback URL as the oAuth_Setup page.  I.E. https://companyname.my.salesforce.com/apex/oAuth_Setup
 
 