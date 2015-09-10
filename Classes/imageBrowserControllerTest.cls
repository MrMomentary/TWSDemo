@isTest private class imageBrowserControllerTest {

    public static testMethod void run()
	{
		imageBrowserController c = new imageBrowserController();		
		
		c.recordName = 'a';
		
		c.objectName = 'Account';
		c.showFilter = 'Contact';
		c.search();
		
		if (c.searchResult.size() > 0){
			c.recordId = c.searchResult[0].id;			
			c.viewThumbnails();
		}
		
		c.objectName = 'Account';
		c.showFilter = 'SiteVisit';
		c.search();
		
		if (c.searchResult.size() > 0){
			for(Account a: c.searchResult){				
				if (a.Site_Visits__r.size() > 0){
					SiteVisit__c sv = a.Site_Visits__r[0];
					c.recordId = sv.id;
					c.viewSiteVisitThumbs();
					break;
				}
				else{
					continue;
				}
			}
		}		
		
		c.objectName = 'Contact';
		c.search();
		
		Integer i = 0;
		for(i=0; i<c.relatedContacts.size(); i++){
			String s; Boolean b; Id id;
			s = c.relatedContacts[i].AssistantName;
			b = c.relatedContacts[i].hasAttachments;			
			s = c.relatedContacts[i].Name;
			id = c.relatedContacts[i].Id;		
		}
		
		c.backToImageSearchAccount();
		c.backToImageSearchSiteVisit();
		c.backToImageSearch();
		
		c.objectName = '';
		c.search(); 
	}
}