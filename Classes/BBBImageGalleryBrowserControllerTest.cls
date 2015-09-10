@isTest private class BBBImageGalleryBrowserControllerTest {

    static testMethod void run() {
    	
        Account a = new Account();
		a.name = 'testAccount24562';
		insert a; 
		
		System.currentPageReference().getParameters().put('id',a.id);
        System.currentPageReference().getParameters().put('filter','Contact');
		System.currentPageReference().getParameters().put('st','algo');
		
		BBBImageGalleryBrowserController c = new BBBImageGalleryBrowserController();
		
		String s = c.getSearchTerm();
		s = c.objectId;
		c.objectId = s;
		s = c.showFilter;
		c.showFilter = s;
		c.qryString = '';
		s = c.qryString;
		c.isSiteVisit = true;
		Boolean b = c.isSiteVisit;
		c.GalleryResultList = new List<GallerySearchResult>();
		List<GallerySearchResult> gsr = c.GalleryResultList;
		c.SiteVisitResult = new SiteVisit__c();
		SiteVisit__c svl = c.SiteVisitResult;
		c.ContactResult = new List<Contact>();
		List<Contact> lc = c.ContactResult;
		
		SiteVisit__c sv = new SiteVisit__c();
		sv.name = 'testSiteVisit24562';
		sv.Latitude__c = '2';
		sv.Longitude__c = '2';
		insert sv; 
		
		System.currentPageReference().getParameters().put('id',sv.id);
		System.currentPageReference().getParameters().put('filter','SiteVisit');
		 c = new BBBImageGalleryBrowserController();
		 
		 delete sv;
		 delete a;
    }
}