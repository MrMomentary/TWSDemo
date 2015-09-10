/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 public abstract class Element {
	
	public string objectType{get;set;}	
	public double distance{get;set;}
	
	public String addressOutput{get{
		return this.getStreet()+ '+' + this.getCity() + ', ' + this.getState() + ' ' + this.getZip() + '+' + this.getCountry();
	}}
	
	public GeoCodedLocation__c geo{get;set;}
	
	public double getLongitude(){return geo.longitude__c;}	
	
	public double getLatitude(){return geo.latitude__c;}		
	
	public void setLongitude(double lon){geo.longitude__c = lon;}
	
	public void setLatitude(double lat){geo.latitude__c = lat;} 
	
	public double getGeoStatus(){return geo.status__c;}
	
	public void setGeoStatus(double status){geo.status__c = status;}
	
	public double getAccuracy(){return geo.accuracy__c;}	
	
	public void setAccuracy(double acc){geo.accuracy__c = acc;}
	
	public abstract Id getId();
	public Id id{get{return getId();}}
	
	public abstract string getName();
	public string name{get{return getName();}}
	
	public abstract string getCountry();
	public abstract string getZip();
	public abstract string getCity();
	public abstract string getState();
	public abstract string getStreet();
	
	public abstract string getPhone();
	public string phone{get{return getPhone();}}
	
	public abstract void updateElement();
	
	public void updateGeoLocation(){
		if((geo != null) && (geo.ParentId__c != null)){
			upsert geo;
		}
	}
	
	public static List<Element> getContacts(Map<ID,GeoCodedLocation__c> geocodes){
		List<Contact> contacts = [SELECT Id, Name, MailingCountry, MailingPostalCode, MailingCity, MailingState, MailingStreet, MobilePhone, Phone, OtherPhone FROM Contact ORDER BY Name];
		List<Element> elements = new List<Element>();
		for(Contact c : contacts){		
			
			ContactElement contactelem = new ContactElement(c);
			if(geocodes.containsKey(c.id)){
				contactelem.geo = geocodes.get(c.id);
			}
			elements.add(contactelem);
		}
		return elements;
	}
	
	public static List<Element> getLeads(Map<ID,GeoCodedLocation__c> geocodes){
		List<Lead> leads = [SELECT Id, Name, Country, PostalCode, City, State, Street, MobilePhone, Phone FROM Lead ORDER BY Name];
		List<Element> elements = new List<Element>();
		for(Lead l : leads){
			
			LeadElement leadelem = new LeadElement(l);
			if(geocodes.containsKey(l.id)){
				leadelem.geo = geocodes.get(l.id);
			}
			elements.add(leadelem);
		}
		return elements;
	}
	
	public static List<Element> getCases(Map<ID,GeoCodedLocation__c> geocodes){
		List<Case> cases = [Select 	
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
								where c.contactId != null or c.accountId != null
							];
								
		List<Element> elements = new List<Element>();
		for(Case c : cases){
			
			CaseElement caselem = new CaseElement(c);
			if(geocodes.containsKey(c.id)){
				caselem.geo = geocodes.get(c.id);
			}
			elements.add(caselem);
		}
		return elements;
	}

	public static Element getContactById(String id,Map<ID,GeoCodedLocation__c> geocodes){
		try{
			Contact obj = [SELECT Id, Name, MailingCountry, MailingPostalCode, MailingCity, MailingState, MailingStreet, MobilePhone, Phone, OtherPhone FROM Contact where Id=:id];
			
			ContactElement contactelem = new ContactElement(obj);
			if(geocodes.containsKey(obj.id)){
				contactelem.geo = geocodes.get(obj.id);
			}			
			return contactelem;		
		}
		catch(Exception e){
			return null;
		}
	}
	
	public static Element getLeadById(String id,Map<ID,GeoCodedLocation__c> geocodes){
		
		try{
			Lead obj = [SELECT Id, Name, Country, PostalCode, City, State, Street, MobilePhone, Phone FROM Lead where Id=:id];
			
			LeadElement leadelem = new LeadElement(obj);
			if(geocodes.containsKey(obj.id)){
				leadelem.geo = geocodes.get(obj.id);
			}			
			return leadelem;
		}
		catch(Exception e){
			return null;
		}
	}
	
	public static Element getUserById(String id,Map<ID,GeoCodedLocation__c> geocodes){
		
		try{
			User obj = [SELECT Id, Name, Country, PostalCode, City, State, Street, MobilePhone, Phone FROM User where Id=:id];
			
			UserElement userelem = new UserElement(obj);
			if(geocodes.containsKey(obj.id)){
				userelem.geo = geocodes.get(obj.id);
			}			
			return userelem;		
		}
		catch(Exception e){
			return null;
		}
	}
	
	public static Element getCaseById(String id,Map<ID,GeoCodedLocation__c> geocodes){
		
		try{
			Case obj = [SELECT c.Id, 
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
									c.AccountId  FROM Case c where Id=:id];
			
			CaseElement caseelem = new CaseElement(obj);
			if(geocodes.containsKey(obj.id)){
				caseelem.geo = geocodes.get(obj.id);
			}			
			return caseelem;		
		}
		catch(Exception e){
			return null;
		}
	}
	
	
	
}