/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 public class LeadElement extends Element{
	
	private Lead obj;
	
	public override String getName(){return obj.Name;}			
	
	public override String getCountry(){return obj.Country;}
	
	public override String getZip(){return obj.PostalCode;}
	
	public override String getState(){return obj.State;}
	
	public override String getCity(){return obj.City;}
	
	public override String getStreet(){return obj.Street;}
	
	public override string getPhone(){
		if(obj.MobilePhone != null){
			return obj.MobilePhone;
		}
		else if (obj.Phone != null){
			return obj.Phone;
		}
		else return '';
	}
	
	public override Id getId(){return obj.id;}

	public LeadElement(Lead l){
		obj = l;	
		objectType = 'Lead';	
		
		geo = new GeoCodedLocation__c();
		geo.ParentId__c = l.id;	
	}	
	
	public override void updateElement(){
		update obj;
	}
}