/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 trigger GeoCoderLeadDelete on Lead (before delete) {
	for(Lead l: trigger.old){	
			delete [SELECT Id,ParentId__c FROM GeoCodedLocation__c WHERE ParentId__c = :l.id];	
	}
}