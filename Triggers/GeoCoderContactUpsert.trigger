/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 trigger GeoCoderContactUpsert on Contact (after update, after insert) {

	for(Integer i=0; i<trigger.new.size(); i++){

		Contact c = trigger.new[i];
		if(trigger.isUpdate){
		
			Contact cold = trigger.old[i];
			if(	c.MailingCountry == cold.MailingCountry &&
				c.MailingPostalCode == cold.MailingPostalCode &&
				c.MailingState == cold.MailingState &&
				c.MailingCity == cold.MailingCity &&
				c.MailingStreet == cold.MailingStreet){
				continue;
			}			
		}		
		ProximitySearchController.upsertGeo(c.id, 'Contact', (c.MailingStreet != null) && (c.MailingCountry != null) && (c.MailingCity != null));
	}
}