/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 @isTest private class GeoCoderTriggersTest {

    static testMethod void run() {
    	
    	ProximitySearchUtil.isTest=true;
    	Contact c =  new Contact(LastName='Dizzy');
    	insert c;
    	delete c;
    	
    	Case ca = new Case();
    	insert ca;
    	delete ca;
    	
    	Lead l = new Lead(LastName='Gonzalez', Company='None');
    	insert l;
    	delete l;   
    }
    
    static testMethod void run2() {   
    	
    	ProximitySearchUtil.isTest=true;
    	User u = [SELECT id, street from User limit 1];
    	string street = u.street;
    	u.street = '^%$';
    	update u; 	
    	u.street = street;
    	update u;
    }
}