/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 public class ProximitySearchController extends BBBController{

	public String mapCenter {get;set;}
	public String objectType{get;set;}
	public string objectId{get;set;}
	public String objectName{get;set;}
	public string maxShown{get;set;}
	public Boolean searchContacts{get;set;}
	public Boolean searchLeads{get;set;}
	public Boolean searchCases{get;set;}
	public string centerLon{get;set;}
	public string centerLat{get;set;}
	public Double lon{get;set;} 
	public Double lat{get;set;}
	public string linkPrefix{get;set;}
	public string cancelLink{get;set;}
	
	public integer zoomLevel{get;set;}
	public integer staticMapHeight{get;set;}
	public integer staticMapWidth{get;set;} 
	
	public List<Element> elems{get;set;}
	
	public string objectErrorMsg{get;set;}
	public string maxShownErrorMsg{get;set;}

	public final double NOT_CALCULATED = 0;
	public final double OK = 1;
	public final double NO_STREET_DATA = 2;
	public final double NOT_FOUND = 3;
	public final double NOT_FOUND_W_O_CITY = 4;
	
	public string key{get;set;}
	
	public GoogleGeoCoder gc;

	public ProximitySearchController(){
		super();
		this.setParameters();
		gc = new GoogleGeoCoder(false);
		lat=null;lon=null;
		elems = new List<Element>();
		key = ProximitySearchUtil.getGoogleMapsKey();
		zoomLevel = 0;
		staticMapHeight = 270;
		staticMapWidth = 320;
	}
	
	public void setParameters(){
	
		if(!params.containsKey('mapCenter')){
			searchContacts = true;
			searchLeads = true;
			searchCases = true;
		}
		else{
			searchContacts = params.containsKey('searchContacts');
			searchLeads = params.containsKey('searchLeads');
			searchCases = params.containsKey('searchCases');
		}
		
		mapCenter = params.get('mapCenter');
		objectType = params.get('objectType');
		objectId = params.get('objectId');
		objectName = params.get('objectName');
		centerLon = params.get('longitude');
		centerLat = params.get('latitude');
		maxShown = params.get('maxShown');
	}
	
	public void perform(){			
		
		try{
			if (isEvent('search')){			
				searchInMap();
				
			}
			else if(isEvent('selectObject')){
				setRedirect(Page.ProximitySearchSelectObject);
			}
		}
		catch(CalloutException e){
			objectErrorMsg = 'Please go to Setup->Security->Remote site settings and add the following endpoint: '+ProximitySearchUtil.getMatch(e.getMessage(),'Unauthorized endpoint.*?(https?.*?)\\?',1);			
			lon = null;
			lat=null;
			elems = new List<Element>();
			return;
		}
	}
	
	public void selectObject(){
		
		if(params.containsKey('selectObject')){
			params.remove('selectObject');
		}
		
		Map<ID,GeoCodedLocation__c> geocodes = new Map<ID,GeoCodedLocation__c>(); 
		for(GeoCodedLocation__c geo: [SELECT latitude__c, longitude__c, accuracy__c, status__c, ParentId__c, id FROM GeoCodedLocation__c]){
			geocodes.put(geo.ParentId__c,geo);
		}
		
		if(objectType == 'Contact'){
			elems = Element.getContacts(geocodes);
			cancelLink = getLinkTo(Page.ProximitySearch);
			if(params.containsKey('objectId')){
				params.remove('objectId');
			}
			if(params.containsKey('objectName')){
				params.remove('objectName');
			}
			params.put('mapCenter','object');
			linkPrefix = getLinkTo(Page.ProximitySearch);
			
		}
		else if(objectType == 'Lead'){
			elems = Element.getLeads(geocodes);
			cancelLink = getLinkTo(Page.ProximitySearch);
			if(params.containsKey('objectId')){
				params.remove('objectId');
			}
			if(params.containsKey('objectName')){
				params.remove('objectName');
			}
			params.put('mapCenter','object');
			linkPrefix = getLinkTo(Page.ProximitySearch);
		}
		else{
			setRedirect(Page.ProximitySearch);
		}				
	}
	
	public void searchInMap(){
	
		Integer max;
		Map<String,Boolean> was = null;		
		//Get contact/lead point
		Element center;
		
		Map<ID,GeoCodedLocation__c> geocodes = new Map<ID,GeoCodedLocation__c>(); 
		for(GeoCodedLocation__c geo: [SELECT latitude__c, longitude__c, accuracy__c, status__c, ParentId__c, id FROM GeoCodedLocation__c]){
			geocodes.put(geo.ParentId__c,geo);
		}
		
		try{
			max = Integer.valueOf(maxShown);
		}
		catch(Exception e){
			maxShownErrorMsg = 'Enter a valid integer number';
			return;
		}
		
		
		
		if (mapCenter == 'currentLocation'){
			try{
				lon = Double.valueOf(centerLon);
				System.assert(lon>=-180 && lon<=180);
				lat = Double.valueOf(centerLat);
			}
			catch(Exception e){

				center = Element.getUserById(UserInfo.getUserId(),geocodes);
				
				was = findCoordinates(center);				
				if(was.get('located')){
					lat = center.getLatitude();
					lon = center.getLongitude();		
				}
				else{
					objectErrorMsg = 'No location information for this User';
					if(was.get('updated')){
						center.updateGeoLocation();
					}
					return;
				}
			}
			
		}		
		else if (mapCenter == 'object'){
			if (objectId == ''){
				objectErrorMsg = 'Please select a contact or lead';
				lon = null;
				lat=null;
				return;
			}			
			
			if (objectType == 'Contact'){
				center = Element.getContactById(objectId,geocodes);					
			}
			else if (objectType == 'Lead'){
				center = Element.getLeadById(objectId,geocodes);			
			}
			else{
				objectErrorMsg = 'Please select contact or lead';
				lon = null;
				lat=null;
				return;
			}
			
			if(center == null){
				objectErrorMsg = 'Select a '+objectType+' from the picklist';
				lon = null;
				lat=null;
				return;
			}
			
			was = findCoordinates(center);				
			if(was.get('located')){
				lat = center.getLatitude();
				lon = center.getLongitude();		
			}
			else{
				objectErrorMsg = 'No location information for the selected '+objectType;
				lon = null;
				lat=null;
				if(was.get('updated')){
					center.updateGeoLocation();
				}
				return;
			}			
		}
		
		if (!searchContacts && !searchLeads && !searchCases){
			return;
		}		
		
		//Search for the nearest contacts/leads/cases				
		if(searchContacts){
			elems.addAll(Element.getContacts(geocodes));		
		}
		if(searchLeads){
			elems.addAll(Element.getLeads(geocodes));
		}
		if(searchCases){
			elems.addAll(Element.getCases(geocodes));
		}	

		elems = sortDistance(filterUnlocated(sortStatus(elems)), lat,lon,max);
		
		zoomLevel = calculateZoomLevel(lat,lon,elems);
		
		if((center != null) && (was != null) && was.get('updated')){
			center.updateGeoLocation();
		}

	}
	
	public integer calculateZoomLevel(double lat, double lon, List<Element>elems){
	
		double minLat = lat;
		double minLon = lon;
		double maxLon = lon;
		double maxLat = lat;
		
		for(Element e: elems){
		
			if(e.getLatitude() > maxLat){
				maxLat = e.getLatitude();
			}
			if(e.getLatitude() < minLat){
				minLat = e.getLatitude();
			}
			if(e.getLongitude() > maxLon){
				maxLon = e.getLongitude();
			}
			if(e.getLongitude() < minLon){
				minLon = e.getLongitude();
			}
		}
		
		double dlat = Math.abs(maxLat-minLat);
		double dlon = Math.abs(maxLon-minLon);		
		if(dlat == 0 && dlon == 0){
        	return 4; 
		}
		
		double zoom = (180/Math.max(dlon,dlat)) * (staticMapWidth/256);
		zoom = Math.floor(Math.log(zoom)/Math.log(2));
		return Math.round(zoom)+1;
		
		double pi = Math.acos(-1);
		double clat = pi*(minLat+maxLat)/360;
		double C = 0.0000107288;
    	integer z0 = Math.round(Math.ceil(Math.log(dlat/(C*staticMapHeight))/Math.log(2)));					 
    	integer z1 = Math.round(Math.ceil(Math.log(dlon/(C*staticMapWidth*Math.cos(clat)))/Math.log(2)));
    	return Math.max(z1,z0);
    	
    	
    	
	}
	
	public List<Element> sortStatus(List<Element> elems){
	
		List<Element> result = new List<Element>();
		Map<Decimal, List<Element>> objMap = new Map<Decimal, List<Element>>();
		
		for(Element e:elems) {       	
   			double status = e.getGeoStatus();
            if(objMap.get(status) == null) { 
            	objMap.put(status, new List<Element>()); 
            }            
            objMap.get(status).add(e);
        }

        List<Decimal> keys = new List<Decimal>(objMap.keySet());
        keys.sort();
               
        for(Decimal key:keys) { 
        	result.addAll(objMap.get(key));
        }  
		return result;
	}
	
	public Map<String,Boolean> findCoordinates(Element e){
			
			Map<String, Boolean> r = new Map<String,Boolean>{'updated'=>false,'located'=>false};
						
			double status = e.getGeoStatus();
			if (status == null){
				status = NOT_CALCULATED;
				e.setGeoStatus(status);
				r.put('updated',true);
			}
			
			if(status >= NOT_FOUND_W_O_CITY){
				status = Math.mod(Math.round(status)+1,10); //Tries location again after 5 searches.
				e.setGeoStatus(status);
				r.put('updated',true);
				return r;
			}
			
			//Find out its coordinates if not present
        	if((status != OK) || (e.getLatitude() == null) || (e.getLongitude() == null)){
        		if ((e.getStreet()!=null) && (e.getCity()!=null) && (e.getCountry()!=null)){
        			try{	
	        			Map<string,double> coords;
	        			//If never calculated or there used to be no address (now there is), try to calculate it
	        			if((status == NOT_CALCULATED) || (status == NO_STREET_DATA)){
		        			coords = gc.getCoordinates(e.getCountry(), e.getZip(), e.getState(), e.getCity(), e.getStreet());
		        			if ((coords == null)){
		        				e.setGeoStatus(NOT_FOUND);
		        				r.put('updated',true);
		        				return r;
		        			}
		        		}
		        		//Maybe wasnt found because of the city...
		        		//http://www.phase9studios.com/2008/07/21/GoogleMapsGeoCoderAPIReturnsCode602.aspx
		        		else if(status == NOT_FOUND){	        		
		        			coords = gc.getCoordinates(e.getCountry(), e.getZip(), e.getState(), '', e.getStreet());
		        			if ((coords == null)){
		        				e.setGeoStatus(NOT_FOUND_W_O_CITY);
		        				r.put('updated',true);
		        				return r;
		        			}
		        		}
		        		else{
		        			return r;
		        		}
		        		
	        			e.setLatitude(coords.get('latitude'));
	        			e.setLongitude(coords.get('longitude'));
	        			e.setAccuracy(coords.get('accuracy'));
	        			e.setGeoStatus(OK);
	        			r.put('updated',true);
        			}
        			catch(GoogleGeoCoderException g){
        				return r;
        			}

        		}
        		else{
        			//Search in another place or discard
        			if (status != NO_STREET_DATA){
        				e.setGeoStatus(NO_STREET_DATA);
	        			r.put('updated',true);
        			}
        			return r;
        		}
        	}
        	
        	r.put('located',true);
        	return r;
	}

	public List<Element> filterUnlocated(List<Element> elems){	
		
		List<Element> result = new List<Element>();
		List<Element> updated = new List<Element>();
		Map<String,Boolean> was;
		
		for(Element e : elems){
			was = findCoordinates(e);				
			if(was.get('updated')){
				updated.add(e);
			}
			if(was.get('located')){
        		result.add(e);
			}			
		}
		//Outside the loop to prevent exception. All http request must take place before any CRUD
		List<GeoCodedLocation__c> geocodes = new List<GeoCodedLocation__c>();
		for(Element e: updated){
			if((e.geo != null) && (e.geo.ParentId__c != null)){				
				geocodes.add(e.geo);
			}
		}
		upsert geocodes;
		return result;
	}
	
	public List<Element> sortDistance(List<Element> elems, double lat, double lon, Integer max){	
	
		List<Element> resultList = new List<Element>();
		Double distance;
		
        Map<Decimal, List<Element>> objMap = new Map<Decimal, List<Element>>();        
        
        GoogleGeoCoder gc = new GoogleGeoCoder(false);
        
        for(Element e:elems) {       	
        	
        	//Build map object to sort by distance
        	distance = gc.distance(lat,lon,e.getLatitude(),e.getLongitude());        	
        	e.distance = distance;     	
            if(objMap.get(distance) == null) { 
            	objMap.put(distance, new List<Element>()); 
            }            
            objMap.get(distance).add(e);
        }
        
        //Do the sort and limit the results
        List<Decimal> keys = new List<Decimal>(objMap.keySet());
        keys.sort();
        
        Integer cantAdded = 0;        
        for(Decimal key:keys) { 
        	if(cantAdded >= max){break;}
        	for(Element e : objMap.get(key)){
        		if(cantAdded >= max){break;}
        		resultList.add(e);
        		cantAdded++;
	        }
        }        
        return resultList;
	}
	
	@future (callout = true)
	public Static void upsertGeo(Id parentId, String parentType, boolean hasLocation){
	
		GeoCodedLocation__c geo;
		try{
			geo = [SELECT latitude__c, longitude__c, accuracy__c, status__c, ParentId__c FROM GeoCodedLocation__c where ParentId__c = :parentId LIMIT 1];
		}
		catch(Exception e){
			geo = new GeoCodedLocation__c();
			geo.ParentId__c = parentId;	
		}
		
		geo.status__c = 0;
		ProximitySearchController c = new ProximitySearchController();
		Map<ID,GeoCodedLocation__c> geocodes = new Map<ID,GeoCodedLocation__c>{parentId=>geo}; 
		Element e;
		if (parentType == 'Contact'){
			e = Element.getContactById(parentId,geocodes);
		}
		else if (parentType == 'Lead'){
			e = Element.getLeadById(parentId,geocodes);
		}
		else if (parentType == 'Case'){
			e = Element.getCaseById(parentId,geocodes);
		}
		else if (parentType == 'User'){
			e = Element.getUserById(parentId,geocodes);
		}
		
		if((e!=null) && !ProximitySearchUtil.isTest){			
			c.filterUnlocated(new List<Element>{e});
			return;
		}
		
		if(!ProximitySearchUtil.isTest){
			upsert geo;
		}
	}
}