/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 trigger GeoCoderLeadUpsert on Lead (after update, after insert) {
	
	for(Integer i=0; i<trigger.new.size(); i++){

		Lead l = trigger.new[i];
		if(trigger.isUpdate){
		
			Lead lold = trigger.old[i];
			if(	l.Country == lold.Country &&
				l.PostalCode == lold.PostalCode &&
				l.State == lold.State &&
				l.City == lold.City &&
				l.Street == lold.Street){
				continue;
			}			
		}
		ProximitySearchController.upsertGeo(l.id, 'Lead', (l.Street != null) && (l.Country != null) && (l.City != null));
	}
}