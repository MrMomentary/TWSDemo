/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 public class ContactElement extends Element{
		  
	private Contact obj;
	
	public override String getName(){return obj.Name;}			
	
	public override String getCountry(){return obj.MailingCountry;}
	
	public override String getZip(){return obj.MailingPostalCode;}
	
	public override String getState(){return obj.MailingState;}
	
	public override String getCity(){return obj.MailingCity;}
	
	public override String getStreet(){return obj.MailingStreet;}
	
	public override string getPhone(){
		if(obj.MobilePhone != null){
			return obj.MobilePhone;
		}
		else if (obj.Phone != null){
			return obj.Phone;
		}
		else if (obj.OtherPhone != null){
			return obj.OtherPhone;
		}
		else return '';
	}
	
	public override Id getId(){return obj.id;}

	public ContactElement(Contact c){
		obj = c;	
		objectType = 'Contact';
		
		geo = new GeoCodedLocation__c();
		geo.ParentId__c = c.id;	
		
	}	
	
	public override void updateElement(){
		update obj; 
	}
}