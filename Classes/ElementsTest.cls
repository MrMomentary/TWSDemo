/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 @isTest private class ElementsTest {

    static testMethod void run() {
    	
    	Map<ID,GeoCodedLocation__c> geocodes = new Map<ID,GeoCodedLocation__c>(); 
		for(GeoCodedLocation__c geo: [SELECT latitude__c, longitude__c, accuracy__c, status__c, ParentId__c, id FROM GeoCodedLocation__c]){
			geocodes.put(geo.id,geo);
		}
    	
		List<Element> elems = Element.getContacts(geocodes);
		Element e = Element.getContactById(elems[0].id,geocodes);		
		
		e.updateGeoLocation();		
		e.setLatitude(e.getLatitude());
		e.setLongitude(e.getLongitude());
		e.setAccuracy(e.getAccuracy());
		e.setGeoStatus(e.getGeoStatus());
		e.getPhone();
		string s = e.addressOutput;
		
		e.updateElement();
		s = e.name;
		e.getCountry();
		e.getZip();
		e.getCity();
		e.getState();
		e.getStreet();
		e.getPhone();
		e.getId();	
		e = Element.getContactById('a',geocodes);
		
		e = new ContactElement(new Contact());
		
		
		elems = Element.getLeads(geocodes);
		e = Element.getLeadById(elems[0].id,geocodes);	
		
		e.updateElement();
		s = e.name;
		e.getCountry();
		e.getZip();
		e.getCity();
		e.getState();
		e.getPhone();
		e.getStreet();
		e.getId();	
		
		e = new LeadElement(new Lead());
		e = Element.getLeadById('a',geocodes);
		
		elems = Element.getCases(geocodes);
		e = new CaseElement([Select 	
									c.Id, 
									c.Contact.MailingCountry, 
									c.Contact.MailingPostalCode, 
									c.Contact.MailingState, 
									c.Contact.MailingCity, 
									c.Contact.MailingStreet, 
									c.Contact.MobilePhone, 
									c.Contact.Phone, 
									c.Contact.OtherPhone, 
									c.ContactId, 
									c.CaseNumber, 
									c.Account.BillingCountry, 
									c.Account.BillingPostalCode, 
									c.Account.BillingState, 
									c.Account.BillingCity, 
									c.Account.BillingStreet, 
									c.Account.Phone,
									c.AccountId 
								From Case c 
								where c.contactId != null or c.accountId != null limit 1]);		
		
		e.updateElement();
		s = e.name;
		e.getCountry();
		e.getZip();
		e.getCity();
		e.getPhone();
		e.getState();
		e.getStreet();
		e.getId();
		
		e = new CaseElement(new Case());
		
		e = Element.getUserById(UserInfo.getUserId(),geocodes);
		
		s = e.name;
		e.getCountry();
		e.getZip();
		e.getCity();
		e.getState();
		e.getStreet();
		e.getPhone();
		e.getId();	
		
		e = new UserElement(new User());
		e = Element.getUserById('a',geocodes);
	}
}