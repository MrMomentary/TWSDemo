@isTest private class BBBImageCaptureControllerTest {

    static testMethod void run() {
        
        Account a = new Account();
		a.name = 'testAccount24562';
		insert a;
		System.currentPageReference().getParameters().put('id',a.Id);
		System.currentPageReference().getParameters().put('objId',a.Id);
		System.currentPageReference().getParameters().put('st','blah');
		
		BBBImageCaptureController c = new BBBImageCaptureController();
		c.step1();
		c.save();
		delete a;
        
        
    }
}