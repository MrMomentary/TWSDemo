@isTest private class AddSiteVisitControllerTest {

    static testMethod void run() {
        Account a = new Account();
		a.name = 'testAccount24562';
		insert a;
		System.currentPageReference().getParameters().put('id',a.id);
		AddSiteVisitController c = new AddSiteVisitController();
		
		c.sv.Name = 'uno';
		c.sv.Latitude__c = '20';
		c.sv.Longitude__c = '10';
		
		c.cancel();
		c.save();
		
		Boolean b = c.showMessage;
		c.showMessage = b;
		
		string s = c.opMessage;
		c.opMessage = s;	
		
		PageReference p = c.goBack;
		
		delete a;
    }
}