@isTest private class BBBAddSiteVisitControllerTest {

    static testMethod void run() {
    	
    	 Account a = new Account();
		a.name = 'testAccount24562';
		insert a;
        System.currentPageReference().getParameters().put('id',a.id);
        System.currentPageReference().getParameters().put('addingSiteVisit','blah');
        
        System.currentPageReference().getParameters().put('siteVisitName','blah');
        System.currentPageReference().getParameters().put('siteVisitNotes','blah');
        System.currentPageReference().getParameters().put('siteVisitLatitude','blah');
        System.currentPageReference().getParameters().put('siteVisitLongitude','blah');
        
        
        BBBAddSiteVisitController c = new BBBAddSiteVisitController();
        
        c.checkAndSave();
        c.save();
        
        
        delete a;
    }
}