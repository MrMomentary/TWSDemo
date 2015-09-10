/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 trigger GeoCoderCaseUpsert on Case (after update, after insert) {

	for(Integer i=0; i<trigger.new.size(); i++){

		Case c = trigger.new[i];
		if(trigger.isUpdate){
		
			Case cold = trigger.old[i];
			if(	c.AccountId == cold.AccountId &&
				c.ContactId == cold.ContactId){
				continue;
			}
		}
		
		ProximitySearchController.upsertGeo(c.id, 'Case', (c.AccountId != null) && (c.ContactId != null));
	}
}