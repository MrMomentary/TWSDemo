/*
* Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
*/

/**
* Test Class to cover code from AccountEditController 
* @author Guillermo Lacordelle
*/ 
@isTest private class ImageBrowserUtilTest
{
	public static testMethod void run()
	{
		Map<String, String> params = ApexPages.currentPage().getHeaders();
		
		params.put('User-Agent', 'iPhone');
		ImageBrowserUtil.getBrowserName();
		
		params.put('User-Agent', 'Salesforce');
		ImageBrowserUtil.getBrowserName();
		
		params.put('User-Agent', 'BlackBerry');
		ImageBrowserUtil.getBrowserName();
		
		params.put('User-Agent', 'other');
		ImageBrowserUtil.getBrowserName();
		
		ImageBrowserUtil.getDomain();
		
		ImageBrowserUtil.strValue('hello');
		ImageBrowserUtil.strValue(null);
		
		boolean b = ImageBrowserUtil.isCSRF(ApexPages.currentPage());
		
		try
		{
			ImageBrowserUtil.doGetRequest('https://login.salesforce.com', null);
		}
		catch (Exception e)
		{
			System.debug(e.getMessage());
		}
		
		try
		{
			ImageBrowserUtil.doGetRequest('https://login.salesforce.com', 'some_cookie_value=true;');
		}
		catch (Exception e)
		{
			System.debug(e.getMessage());
		}
		
		
		ImageBrowserUtil.encode('String to encode');
		
		System.assert(ImageBrowserUtil.getMatch('Hello world', 'w(.*)d', 1) == 'orl');
		
		System.assert(ImageBrowserUtil.boundLower('This is a string', 'is') == ' is a string');
		
		System.assert(ImageBrowserUtil.boundUpper('This is a string', 'a') == 'This is ');
		
		System.assert(ImageBrowserUtil.bound('This is a string', 'a', 'ing') == ' str');
	}
}