/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 @isTest private class TimerTest {

    static testMethod void run() {
        ProximitySearchUtil.isTest = true;
        Timer.waitRequest(1000);
        Timer.waitMinIntervalRequest(1000,Datetime.now().getTime()-2000);
        Timer.waitMinIntervalRequest(1000,Datetime.now().getTime()-1000);
        Timer.waitMinIntervalRequest(1000,Datetime.now().getTime()-500);
        Map<String,String> params = System.currentPageReference().getParameters();
        params.put('fcn','wait');
        params.put('millis','200');
        Timer t = new Timer();
        
        params.put('fcn','waitMinInterval');
        params.put('interval','500');
        params.put('last',String.valueOf(Datetime.now().getTime()));
        t = new Timer();
    }
}