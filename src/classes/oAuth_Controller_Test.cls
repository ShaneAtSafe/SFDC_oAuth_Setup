/**
 *  Test Class for oAuth_Controller
 *
 *   @Author: Shane Jensen
 *   @Date: 03/2015
 **/
@isTest
private class oAuth_Controller_Test {
	private static oAuth_Controller oAuthCtlr;

	@isTest
	static void load_page_run_step1() {
		PageReference pageRef = Page.oAuth_Setup;
		Test.setCurrentPage(pageRef);

		oAuthCtlr = new oAuth_Controller();

		oAuthCtlr.client_key = '1234567890';
		PageReference step1 = oAuthCtlr.generate_oAuth_step1();
		System.debug('step1='+step1);
	}

	@isTest
	static void load_page_run_step2() {
		PageReference pageRef = Page.oAuth_Setup;
		pageRef.getParameters().put('state', 'step2');
		Test.setCurrentPage(pageRef);

		oAuthCtlr = new oAuth_Controller();

		oAuthCtlr.auth_code = 'abcdefghijklmnopqrstuvwxyz';
		oAuthCtlr.client_key = '1234567890';
		oAuthCtlr.client_secret = 'helloworld';

		//oAuthCtlr.generate_oAuth_step2();
		//Could add HTTP Mock callout to catch webservice call.
	}

	@isTest
	static void load_page_run_error() {
		PageReference pageRef = Page.oAuth_Setup;
		pageRef.getParameters().put('error', '99999');
		pageRef.getParameters().put('error_description', 'Test error description!');
		Test.setCurrentPage(pageRef);
	}

	@testSetup
	static void setup_test_data() {
		AuthSettings__c s = new AuthSettings__c(Name='Standard', URL__c = 'https://login.salesforce.com');
		insert s;
	}
}