/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 @isTest private class BBBControllerTest {

    static testMethod void run() {
    	
    	BBBController c = new BBBController();
    	PageReference pr = new PageReference('http://www.force.com');
    	c.getLinkTo(pr);
    	c.setRedirect(pr);
    	c.isEvent('');
    	c.getParamsString();
    }
}