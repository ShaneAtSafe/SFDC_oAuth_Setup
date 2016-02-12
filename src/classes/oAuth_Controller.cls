/**
 *  Controller for page that allows us to call an internal Connected App with the Client Secret and Key, and get the token back.
 *
 *  @Author: Shane Jensen
 *  @Date: 02/2015
 *	@References:
 *	https://www.salesforce.com/us/developer/docs/api_rest/Content/intro_understanding_web_server_oauth_flow.htm
 *	https://help.salesforce.com/HTViewHelpDoc?id=remoteaccess_oauth_scopes.htm&language=en_US
 */
public with sharing class oAuth_Controller {
	public String client_key {get; set;}
	public String scope {get; set;}
	public String client_secret {get; set;}
	public String access_token {get; set;}
	public String refresh_token {get; set;}
	public String auth_code {get; set;}
	public Boolean show_step1 {get; private set;}
	public Boolean show_step2 {get; private set;}
	public Boolean show_step3 {get; private set;}

	private String salesforce_url;
	private auth_response rt;

	public oAuth_Controller() {
		AuthSettings__c oAuthSettings = new AuthSettings__c();
		oAuthSettings = AuthSettings__c.getValues('Standard');
		salesforce_url = oAuthSettings.URL__c;
		System.debug('salesforce_url='+salesforce_url);
		show_step1 = true;
		show_step2 = false;
		show_step3 = false;
		scope = 'full refresh_token';
		String state = ApexPages.currentPage().getParameters().get('state');
		String error = ApexPages.currentPage().getParameters().get('error');
		String error_description = ApexPages.currentPage().getParameters().get('error_description');
		auth_code = ApexPages.currentPage().getParameters().get('code');

		if (error != null)
			ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, error + ': ' +error_description));
		if(state == 'step2') {
			show_step1 = false;
			show_step2 = true;
		}
	}

	public PageReference generate_oAuth_step1 () {
		String auth_url = salesforce_url + '/services/oauth2/authorize';
    	String params = '?response_type=code' +
			'&client_id=' + EncodingUtil.urlEncode(client_key,'UTF-8') +
			'&redirect_uri=' + salesforce_url + '/apex/oAuth_Setup' +
			'&prompt=consent' +
			'&scope=' + EncodingUtil.urlEncode(scope,'UTF-8') +
			'&state=step2';
        PageReference pr = New PageReference(auth_url + params);
        return pr;
	}

	public void generate_oAuth_step2 (){
	    HttpRequest req = new HttpRequest();
	    Http http = new Http();

	    String auth_url = salesforce_url + '/services/oauth2/token';
	    String params = '?code=' + auth_code +
	        '&grant_type=authorization_code' +
	        '&client_id=' + EncodingUtil.urlEncode(client_key,'UTF-8') +
	        '&client_secret=' + EncodingUtil.urlEncode(client_secret, 'UTF-8') +
	        '&redirect_uri=' + salesforce_url + '/apex/oAuth_Setup';

	    req.setMethod('POST');
	    req.setEndpoint(auth_url + params);

	    HTTPResponse resp = http.send(req);

	    System.debug('Step 2 - response:'+resp);
	    System.debug('Step 2 - resp.getBody():'+resp.getBody());

	    rt = (auth_response)json.deserialize(resp.getBody(),auth_response.class);
	    //Do something with the results
	    access_token = rt.access_token;
	    refresh_token = rt.refresh_token;
	    show_step2 = false;
	    show_step3 = true;
	    System.debug('access_token:'+access_token);
	    System.debug('refresh_token:'+refresh_token);
	}

	private class auth_response{
	    public string refresh_token;
	    public string access_token;
	}
}