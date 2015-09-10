/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 public class GoogleGeoCoder {

	private String key;
	private Boolean sensor;	
	
	static final Long INTERVAL = 1725; 	//Google's minimum delay (milliseconds) between Geocoder service requests.
	static final Integer MAXTRIES = 10; //Apex request limitations sets max request to 10
	
	private static Long timestamp = Datetime.now().getTime()-INTERVAL; 	//Last time a request was made
	private static Integer tries = 0;									//Actual number of tries.

	public GoogleGeoCoder(Boolean sensor){
	
		this.key = ProximitySearchUtil.getGoogleMapsKey();
		this.sensor = sensor;
	}
	
	public Map<String,Double> getCoordinates(String country, String zip, String province, String city, String address){
	
		if(tries == MAXTRIES){
			throw new GoogleGeoCoderException('No more requests!');
		}
		
		String query = address + ', '  + city + ', ' + province /* + ' ' + zip + ' ' + country */;
		query = query.replaceAll('[\\s]+', '+'); 
		
		String requestUrl = 'http://maps.google.com/maps/geo?output=csv&oe=utf8&key='+key+'&sensor=';
		
		if (sensor){
			requestUrl = requestUrl+'true&q=';		
		}
		else{
			requestUrl = requestUrl+'false&q='; 
		}		
		requestUrl = requestUrl + query;		
		
		String[] values;
		
		if(!ProximitySearchUtil.isTest){ //CALLOUTS NOT SUPPORTED INSIDE TESTS
		
			HttpRequest req = new HttpRequest();
			req.setMethod('GET');
			req.setEndpoint(requestUrl);			  
			Http http = new Http();
			HTTPResponse res;					
			Integer statusCode = 0;
	
			while ((tries < MAXTRIES) && (statusCode != 200)){
				
				long span = interval-Datetime.now().getTime()+timestamp;			
	
				if(span>0){
					
					if(tries+2>MAXTRIES){
						throw new GoogleGeoCoderException();		//SKIP BOTH	
					}				
					Timer.waitMinIntervalRequest(INTERVAL, timestamp); //HTTP REQUEST WITH BUSY WAITING AT THE ENDPOINT!!!
					tries++;
				}
				res = http.send(req);
				timestamp = Datetime.now().getTime();			 
				tries++;
				statusCode = res.getStatusCode();
			} 
			
			if ((statusCode != 200)){		
				return null;		
			}				
			
			values = res.getBody().split('\n')[0].split(',');
		}
		else{
			values = new String[]{'200','8','24','8'};
		}
		
		
		if (values[0] == '620'){
			throw new GoogleGeoCoderException(); //Skip
		}
		if (values[0] != '200'){
			return null;
		}
		
		try{
		
		return new Map<String,Double>{	'accuracy'=>Double.valueOf(values[1]),
										'latitude'=>Double.valueOf(values[2]),
										'longitude'=>Double.valueOf(values[3])		
		};
		
		}catch(Exception e){throw new GoogleGeoCoderException(e.getMessage());}
		
		
		/*
		//This statement causes trouble with large responses throws Too many statements: 200001
		JSONObject json;
		json = JSONObject.instance(res.getBody());
		json.stripQuotes = true;
		
		if (json.xpath('Status/code') != '200'){
			return null;	
		}	
		
		try{			

			double lon = Double.valueOf(json.xpath('Placemark[0]/Point/coordinates[0]'));
			double lat = Double.valueOf(json.xpath('Placemark[0]/Point/coordinates[1]'));
			double accuracy = Double.valueOf(json.xpath('Placemark[0]/AddressDetails/Accuracy'));
			Map<String,double> coordMap = new Map<String,double>{'longitude'=>lon, 'latitude'=>lat, 'accuracy'=>accuracy};
			return coordMap;
			
		}
		catch(Exception e){
			throw new GoogleGeoCoderException(e.getMessage());	
		}
		*/		
	}
	
	public double distance(double Alat,double Alon,double Blat,double Blon){
	
		double earthRadius = 6371.01;
		double pi = Math.acos(-1);
		//Convert to radians
		double AlonRad = (pi*Alon)/180;
		double AlatRad = (pi*Alat)/180;
		double BlonRad = (pi*Blon)/180;
		double BlatRad = (pi*Blat)/180;
		double dlon = BlonRad-AlonRad; 
		
		//Accurate, low error formula taken from http://en.wikipedia.org/wiki/Great-circle_distance
		return 	earthRadius
				*
				Math.atan(
					Math.pow(
						Math.pow(Math.cos(BlatRad)*Math.sin(dlon),2)
						+
						Math.pow(Math.cos(AlatRad)*Math.sin(BlatRad) - Math.sin(AlatRad)*Math.cos(BlatRad)*Math.cos(dlon)
							,
							2						
						)
						,
						0.5
					)
					/
					(
					Math.sin(AlatRad)*Math.sin(BlatRad) + Math.cos(AlatRad)*Math.cos(BlatRad)*Math.cos(dlon)
					)
				);
	}
}