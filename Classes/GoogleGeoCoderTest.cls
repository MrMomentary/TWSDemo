/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 @isTest private class GoogleGeoCoderTest {

    static testMethod void run() {
        ProximitySearchUtil.isTest = true;
        GoogleGeoCoder g = new GoogleGeoCoder(false);
		
		for(integer i=0; i<10; i++){		
			g.getCoordinates('Uruguay','11800','Montevideo','Montevideo','Colón 797'); 
		}		
		g.distance(40,40,0,0);
    }
}