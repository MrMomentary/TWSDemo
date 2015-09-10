/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 public class CaseElement extends Element{
		
	private Case obj;

	public override String getName(){return obj.CaseNumber;}			
	
	public override String getCountry(){return Country;}
	
	public override String getZip(){return Zip;}
	
	public override String getState(){return State;}
	
	public override String getCity(){return City;}
	
	public override String getStreet(){return Street;}
	
	public override string getPhone(){return daPhone;}
	
	public override Id getId(){return obj.id;}
	
	private string Country;
	private string Zip;
	private string State;
	private string City;
	private string Street;
	private string daPhone;
 
	public CaseElement(Case c){
		
		obj = c;		
		objectType = 'Case'; 
		Boolean found = false;
		
		geo = new GeoCodedLocation__c();
		geo.ParentId__c = c.id;
		
		if (c.contactId != null){
			Contact ct = c.Contact;
			if (ct.MailingCountry!=null && ct.MailingCity!=null && ((ct.MailingStreet!=null)||(ct.MailingPostalCode!=null))){
				this.City = ct.MailingCity;
				this.Country = ct.MailingCountry;
				this.Zip = ct.MailingPostalCode;
				this.Street = ct.MailingStreet;
				this.State = ct.MailingState;
				found = true;				
				
				if(ct.MobilePhone != null){
					daPhone = ct.MobilePhone;
				}
				else if (ct.Phone != null){
					daPhone = ct.Phone;
				}
				else if (ct.OtherPhone != null){
					daPhone = ct.OtherPhone;
				}
				else daPhone = '';
				
			}				
		}
		if (!found && c.accountId != null){
			Account a = c.Account;
			if (a.BillingCountry!=null && a.BillingCity!=null && ((a.BillingStreet!=null)||(a.BillingPostalCode!=null))){
				this.City = a.BillingCity;
				this.Country = a.BillingCountry;
				this.Zip = a.BillingPostalCode;
				this.Street = a.BillingStreet;
				this.State = a.BillingState;
				found = true;			
				
				daPhone = a.Phone;				
			}
		}	
		if (!found){
			this.City = null;
			this.Country = null;
			this.Zip = null;
			this.Street = null;
			this.State = null;
			this.daPhone = null;
		}
	}	
	
	public override void updateElement(){
		update obj;
	}
}