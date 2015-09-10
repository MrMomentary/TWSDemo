@isTest private class BBBSearchResultControllerTest {

    public static testMethod void run()
	{
		
		System.currentPageReference().getParameters().put('obj','Account');
		System.currentPageReference().getParameters().put('searchTerm','a');
		System.currentPageReference().getParameters().put('filter','SiteVisit');

		
		BBBSearchResultController c = new BBBSearchResultController();		
		
		string s = c.getFilter();
		s = c.getSearchTerm();
		
		
		System.currentPageReference().getParameters().put('obj','Account');
		System.currentPageReference().getParameters().put('searchTerm','a');
		System.currentPageReference().getParameters().put('filter','Contact');

		
		c = new BBBSearchResultController();	
		
		System.currentPageReference().getParameters().put('obj','Contact');
		System.currentPageReference().getParameters().put('searchTerm','a');

		
		c = new BBBSearchResultController();	
	}
}