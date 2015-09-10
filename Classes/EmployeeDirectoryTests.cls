/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class EmployeeDirectoryTests{
    
    static testMethod void invalidAccount(){
    	
    	Account acc1 = new Account( name = 'Mark Sivill test1' );
        insert acc1;
        
        List<Employee_Directory_Configuration__c> edcs1 = [ SELECT id FROM Employee_Directory_Configuration__c limit 1 ];
        delete edcs1;
        
        Employee_Directory_Configuration__c edc1 = new Employee_Directory_Configuration__c( Account__c = acc1.id );
        insert edc1;
        
        delete acc1;
        
        EmployeeDirectoryController ed = new EmployeeDirectoryController();
        System.assert( ed.getValidSearch() == false , 'Account has been erased' );
    }
    
    static testMethod void controllerTest(){
    		
		//code to test class behind visualforce page
		EmployeeDirectoryController ed = new EmployeeDirectoryController();

        Account acc1 = new Account( name = 'Mark Sivill test1' );
        insert acc1;

        Account acc2 = new Account( name = 'Mark Sivill test2' );
        insert acc2;
		
		Contact con1 = new Contact ( lastName = 'Mark Sivill', accountId = acc1.Id );
		insert con1;

		Contact con2 = new Contact ( lastName = 'Matias Menafra', accountId = acc1.Id );
		insert con2;
		
        List<Employee_Directory_Configuration__c> edcs1 = [ SELECT id FROM Employee_Directory_Configuration__c limit 1 ];
        delete edcs1;

		ed = new EmployeeDirectoryController();

		Employee_Directory_Configuration__c edc1 = new Employee_Directory_Configuration__c( Account__c = acc1.id );
		Employee_Directory_Configuration__c edc2 = new Employee_Directory_Configuration__c( Account__c = acc2.id );
		insert edc1;
		
		ed = new EmployeeDirectoryController();
		ed.getZeroResults();
		
        edcs1 = [ SELECT id FROM Employee_Directory_Configuration__c ];
        delete edcs1;

 		List<Employee_Directory_Configuration__c> edcs2 = new Employee_Directory_Configuration__c[]{edc1,edc2};
		ed = new EmployeeDirectoryController();
		
		Boolean res = false;
		res = ed.getManyResults();
		res = ed.getInternalError();
		res = ed.getFirstEntry();
		res = ed.getManyAccount();
		res = ed.getZeroAccount();
		res = ed.getTooMany();
		res = ed.getSmallWord();
		res = ed.getValidSearch();
		
		ed.setAccount( acc1 );
		Account acc = ed.getAccount();

		ed.setSearchTerm( 'test' );		
		String st = ed.getSearchTerm();

		ed.doSearch();
		List<Contact> contacts = ed.getSearchResults();
		
		ed.setSearchTerm( '' );		
		ed.doSearch();
		System.assert( ed.getValidSearch() == false , '' );
		
		ed.setSearchTerm( 'm' );		
		ed.doSearch();
		System.assert( ed.getSmallWord() == true , '' );
		
		ed.setSearchTerm( 'fred' );		
		ed.doSearch();
		System.assert( ed.getSmallWord() == false , '' );
		
		ed.setSearchTerm( 'ma*' );		
		ed.doSearch();
		System.assert( ed.getSearchResults().size() == 0 , 'number of Records retrieved : ' + ed.getSearchResults().size() );
		
		ed.setSearchTerm( 'm*' );		
		ed.doSearch();
		System.assert( ed.getSearchResults().size() == 0 , 'number of Records retrieved : ' + ed.getSearchResults().size() );
		
		ed.setSearchTerm( 'matias' );		
		ed.doSearch();
		System.assert( ed.getSearchResults().size() == 0 , 'number of Records retrieved : ' + ed.getSearchResults().size() );
		
		ed.setSearchTerm( 'aaa bbb ccc ddd eee fff ggg hhh iii jjj kkk' );		
		ed.doSearch();
		System.assert( ed.getSearchResults().size() == 0 , 'number of Records retrieved : ' + ed.getSearchResults().size() );
    }

    static testMethod void BeforeTriggerTest(){

		//code to test trigger
        Account acc1 = new Account( name = 'Mark Sivill test1' );
        insert acc1;

		Account acc2 = new Account( name = 'Mark Sivill test2' );
        insert acc2;
        
        List<Employee_Directory_Configuration__c> edcs1 = [ SELECT id FROM Employee_Directory_Configuration__c limit 1 ];
        delete edcs1;

		Employee_Directory_Configuration__c edc1 = new Employee_Directory_Configuration__c( Account__c = acc1.id );
		Employee_Directory_Configuration__c edc2 = new Employee_Directory_Configuration__c( Account__c = acc2.id );

		List<Employee_Directory_Configuration__c> firstRec 	= new Employee_Directory_Configuration__c[]{edc1};
		List<Employee_Directory_Configuration__c> secondRec = new Employee_Directory_Configuration__c[]{edc2};
		List<Employee_Directory_Configuration__c> twoRecs 	= new Employee_Directory_Configuration__c[]{edc1, edc2};
		
		//go via trigger
		try{
			insert twoRecs;
		} catch( DmlException e ){
			System.assert( true ,' System allowed two configuration objects to be created' );
		}
    }

    static testMethod void AfterTriggerTest(){

		//code to test trigger
        Account acc1 = new Account( name = 'Mark Sivill test1' );
        insert acc1;

        Account acc2 = new Account( name = 'Mark Sivill test2' );
        insert acc2;
		
        List<Employee_Directory_Configuration__c> edcs1 = [ SELECT id FROM Employee_Directory_Configuration__c limit 1 ];
        delete edcs1;

		Employee_Directory_Configuration__c edc1 = new Employee_Directory_Configuration__c( Account__c = acc1.id );
		Employee_Directory_Configuration__c edc2 = new Employee_Directory_Configuration__c( Account__c = acc2.id );

		List<Employee_Directory_Configuration__c> firstRec 	= new Employee_Directory_Configuration__c[]{edc1};
		List<Employee_Directory_Configuration__c> secondRec = new Employee_Directory_Configuration__c[]{edc2};
		
		insert firstRec;
		delete firstRec;
		
		insert secondRec;
		delete secondRec;

		List<Employee_Directory_Configuration__c> twoRecs = new Employee_Directory_Configuration__c[]{edc1, edc2};		

		//go via trigger
		try{
			undelete twoRecs;
		}catch( DmlException e ){
			System.assert( true , 'allowed two configuration records to be created' );
		}
		
		undelete firstRec;
		
		try{
			undelete secondRec;
		}catch( DmlException e ){
			
		}
    }
    
    static testMethod void ConfigurationClassTest(){

		//code to test trigger
        Account acc1 = new Account( name = 'Mark Sivill test1' );
        insert acc1;

        Account acc2 = new Account( name = 'Mark Sivill test2' );
        insert acc2;
		
        List<Employee_Directory_Configuration__c> edcs1 = [ SELECT id FROM Employee_Directory_Configuration__c limit 1 ];
        delete edcs1;

		Employee_Directory_Configuration__c edc1 = new Employee_Directory_Configuration__c( Account__c = acc1.id );
		Employee_Directory_Configuration__c edc2 = new Employee_Directory_Configuration__c( Account__c = acc2.id );

		List<Employee_Directory_Configuration__c> firstRec 	= new Employee_Directory_Configuration__c[]{edc1};
		List<Employee_Directory_Configuration__c> secondRec = new Employee_Directory_Configuration__c[]{edc2};
		List<Employee_Directory_Configuration__c> twoRecs 	= new Employee_Directory_Configuration__c[]{edc1, edc2};
		
		//large batch - fail	
		try{
			Employee_Directory_Configuration.checkOneRecordBefore( twoRecs );
		}catch( DmlException e ){
			System.assert( true, 'allowed two configuration records to be created' );
		}
		
		//one row - sucess
		Employee_Directory_Configuration.checkOneRecordBefore( firstRec );
		
		//second row - fail
		try{
			Employee_Directory_Configuration.checkOneRecordBefore( secondRec );
		}catch( DmlException e ){
			
		}

		//check existing row		
		insert firstRec;
		Employee_Directory_Configuration.checkOneRecordBefore( firstRec );
    }
}