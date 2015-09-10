/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 trigger GeoCoderUserUpsert on User (after update, after insert) {

	
	for(Integer i=0; i<trigger.new.size(); i++){

		User u = trigger.new[i];
		if(trigger.isUpdate){
		
			User uold = trigger.old[i];
			if(	u.Country == uold.Country &&
				u.PostalCode == uold.PostalCode &&
				u.State == uold.State &&
				u.City == uold.City &&
				u.Street == uold.Street){
				continue;
			}			
		}
		
		ProximitySearchController.upsertGeo(u.id, 'User', (u.Street != null) && (u.Country != null) && (u.City != null));
		
	}
}