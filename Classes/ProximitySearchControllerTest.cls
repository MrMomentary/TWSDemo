/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 @isTest private class ProximitySearchControllerTest {

    static testMethod void run() {
    	
    	ProximitySearchUtil.isTest = true;
    	Test.setCurrentPage(Page.ProximitySearch);
    	
    	Contact ctc = new Contact(LastName='Felipe', MailingStreet='Venezuela 1200', MailingCountry='Uruguay', MailingCity='Montevideo');
    	insert ctc;
    	
    	Map<String,String> params = System.currentPageReference().getParameters();
    	params.put('search','');
    	params.put('mapCenter','currentLocation');
		params.put('objectType','Contact');
		params.put('objectId','');
		params.put('objectName','');
		params.put('longitude','');
		params.put('latitude','');		
		params.put('maxShown','5');
		params.put('searchContacts','On');
		params.put('searchLeads','On');
		params.put('searchCases','On');
    	
    	ProximitySearchController c;
    	c = new ProximitySearchController();
    	c.perform();
    	
    	delete ctc;
    
		params.put('longitude','45');
		params.put('latitude','45');	
    	
    	c = new ProximitySearchController();
    	c.perform();
    	
    	
    	params.put('mapCenter','object');
    	params.put('longitude','');
		params.put('latitude','');	
		params.put('objectId','');
		params.put('objectName','');
		
		c = new ProximitySearchController();
    	c.perform();
    	
    	
    	ctc = new Contact();
    	ctc.LastName = 'Nelson';
    	insert ctc;
    	params.put('objectId',ctc.id);
		params.put('objectName','William');
		
		c = new ProximitySearchController();
    	c.perform();
    	delete ctc;
    	
    }
    
    static testMethod void run2() {

		ProximitySearchUtil.isTest = true;
		Test.setCurrentPage(Page.ProximitySearch);
    	Map<String,String> params = System.currentPageReference().getParameters();
    	
    	params.remove('search');
    	params.put('selectObject','');
    	params.put('mapCenter','currentLocation');
		params.put('objectType','Contact');
		params.put('objectId','');
		params.put('objectName','');
		params.put('longitude','');
		params.put('latitude','');		
		params.put('maxShown','5');
		params.put('searchContacts','On');
		params.put('searchLeads','On');
		params.put('searchCases','On');
		
		ProximitySearchController c = new ProximitySearchController();
    	c.selectObject();
    	
    	
    	
    	params.put('objectType','Lead');
    	c = new ProximitySearchController();
    	c.selectObject();
	}
	
	static testMethod void run3() {

		ProximitySearchUtil.isTest = true;
		Test.setCurrentPage(Page.ProximitySearch);
    	Map<String,String> params = System.currentPageReference().getParameters();
    	
    	params.put('search','');
    	params.put('mapCenter','currentLocation');
		params.put('objectType','Contact');
		params.put('objectId','');
		params.put('objectName','');
		params.put('longitude','');
		params.put('latitude','');
		params.put('maxShown','4t');
		ProximitySearchController c = new ProximitySearchController();
    	c.perform(); 		
		
		params.put('searchContacts','On');
		params.put('searchLeads','On');
		params.put('searchCases','On');
		
		
		params.put('maxShown','4t');
		c = new ProximitySearchController();
    	c.perform();  	
    	
    	
    	params.put('mapCenter','object');
		params.put('objectType','Contact');
		params.put('objectId','pepe');
		params.put('objectName','El pepe');
		c = new ProximitySearchController();
    	c.perform(); 
    	
    	
    	
    	params.remove('search');
    	params.put('selectObject','');
    	params.put('objectType','Lead');
    	c = new ProximitySearchController();
    	c.selectObject();
    	
    	params.put('objectId','2');
    	params.put('objectName','2');
    	c = new ProximitySearchController();
    	c.selectObject();
    	
    	params.put('objectType','Leadsasdf');
    	c = new ProximitySearchController();
    	c.selectObject();
	}
}