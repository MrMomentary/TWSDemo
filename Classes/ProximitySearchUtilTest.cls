/*
* Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
*/

/**
* Test Class to cover code from AccountEditController 
* @author Guillermo Lacordelle
*/ 
@isTest private class ProximitySearchUtilTest
{
	public static testMethod void run()
	{
		ProximitySearchUtil.isTest = true;
		Map<String, String> params = ApexPages.currentPage().getHeaders();
		
		params.put('User-Agent', 'iPhone');
		ProximitySearchUtil.getBrowserName();
		
		params.put('User-Agent', 'Salesforce');
		ProximitySearchUtil.getBrowserName();
		
		params.put('User-Agent', 'BlackBerry');
		ProximitySearchUtil.getBrowserName();
		
		params.put('User-Agent', 'other');
		ProximitySearchUtil.getBrowserName();
		
		ProximitySearchUtil.getDomain();
		
		ProximitySearchUtil.strValue('hello');
		ProximitySearchUtil.strValue(null);
		ProximitySearchUtil.getGoogleMapsKey();
		
		System.currentPageReference().getHeaders().put('Referer','http://www.google.com');
		boolean b = ProximitySearchUtil.isCSRF(new PageReference('http://www.google.com'));
		b = ProximitySearchUtil.isCSRF(new PageReference('http://www.googlerrrr.com'));
		
		try
		{
			ProximitySearchUtil.doGetRequest('https://login.salesforce.com', null);
		}
		catch (Exception e)
		{
			System.debug(e.getMessage());
		}
		
		try
		{
			ProximitySearchUtil.doGetRequest('https://login.salesforce.com', 'some_cookie_value=true;');
		}
		catch (Exception e)
		{
			System.debug(e.getMessage());
		}
		
		
		ProximitySearchUtil.encode('String to encode');
		
		System.assert(ProximitySearchUtil.getMatch('Hello world', 'w(.*)d', 1) == 'orl');
		
		System.assert(ProximitySearchUtil.boundLower('This is a string', 'is') == ' is a string');
		
		System.assert(ProximitySearchUtil.boundUpper('This is a string', 'a') == 'This is ');
		
		System.assert(ProximitySearchUtil.bound('This is a string', 'a', 'ing') == ' str');
	}
}