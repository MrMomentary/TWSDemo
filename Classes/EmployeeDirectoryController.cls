/**
 Copyright (c) 2008, Mark Sivill, Sales Engineering, Salesforce.com Inc.
 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
 Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
 EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 History

 Version	Date			Author			Comments
 1.0		18-10-2008		Mark Sivill		Initial version

 NOTE - largest return size for SOSL statement is 200 records, if search words are returned
 that result in over 200 records per search (for example 'Smith') then not all
 records will be displayed
*/
public with sharing class EmployeeDirectoryController{

	//main data
	private Account 		theAccount;
	private String 			searchTerm; 
	private String[] 		searchWords; 
	private List<Contact> 	searchResults; 
		
	//status flags	
	private Boolean validSearch 	= false;
	private Boolean firstEntry 		= false;
	private Boolean tooMany 		= false;
	private Boolean smallWord 		= false;
	private Boolean zeroAccount 	= false;
	private Boolean manyAccount 	= false;
	private Boolean internalError 	= false;
	private Boolean manyResults 	= false;
	private Boolean zeroResults 	= false;
	
	/**
	* Constructor
	*/
  	public EmployeeDirectoryController(){
		
		this.theAccount 	= new Account();
		this.searchTerm 	= '';
		this.searchWords 	= new String[]{};
		this.searchResults 	= new List<Contact>();
		
  		//should only be one account in configuration object, perform relevant checks
  		List<Employee_Directory_Configuration__c> edcs = [ SELECT e.id, e.Account__c FROM Employee_Directory_Configuration__c e limit 1];
  		
  		if( edcs.size() == 1 ){
  			if( edcs[0].Account__c != null ){
  				this.theAccount 	= [ SELECT a.Name, a.Id	FROM Account a	WHERE a.id =: edcs[0].Account__c limit 1 ];
		  		this.validSearch 	= true;
				this.firstEntry 	= true;
  			}else{
  				this.internalError	= true;
  			}
  		}
  		else if( edcs.size() == 0 ){
  			this.theAccount.Name 	= '';
	  		this.validSearch 		= false;
	  		this.zeroAccount 		= true;
  		}
	}

	/**
	* Getter method for acocunt object
	* @return theAccount
	*/
	public Account getAccount(){
		return this.theAccount;
	}
	
	/**
	* Setter method for account object
	* @param theAccount
	*/
	public void setAccount( Account theAccount ){
		this.theAccount = theAccount;
	}
	
	/**
	* Getter method for Serach Term
	* @return searchTerm
	*/
	public String getSearchTerm(){
		return searchTerm;
	}
	
	/**
	* Setter method for Search Term
	* @param searchTerm
	*/
	public void setSearchTerm( String searchTerm ){
		this.searchTerm = searchTerm;		
	}
	
	/**
	* Getter method for searchResults List
	* @return searchResults
	*/
	public List<Contact> getSearchResults(){
		return this.searchResults;
	}

	/**
	* Getter method for manyResults attribute
	* @return manyResults
	*/
	public Boolean getManyResults(){
		return this.manyResults;
	}
	
	/**
	* Getter method for internalError attribute
	* @return internalError
	*/
	public Boolean getInternalError(){
		return this.internalError;
	}
	
	/**
	* Getter method for firstEntry attribute
	* @return firstEntry
	*/
	public Boolean getFirstEntry(){
		return this.firstEntry;
	}
	
	/**
	* Getter method for manyAccount attribute
	* @return manyAccount
	*/
	public Boolean getManyAccount(){
		return this.manyAccount;
	}
	
	/**
	* Getter method for zeroAccount attribute
	* @return zeroAccount
	*/
	public Boolean getZeroAccount(){
		return this.zeroAccount;
	}
	
	/**
	* Getter method for tooMany attribute
	* @return tooMany
	*/
	public Boolean getTooMany(){
		return this.tooMany;
	}
	
	/**
	* Getter Method for smallWord attribute
	* @return smallWord
	*/
	public Boolean getSmallWord(){
		return this.smallWord;
	}
	
	/**
	* Getter Method for validSearch attribute
	* @return validSearch
	*/
	public Boolean getValidSearch(){
		return this.validSearch;
	}
	
	/**
	* Getter Method for zeroResults attribute
	* @return zeroResults
	*/	
	public Boolean getZeroResults(){
		return this.zeroResults;
	}
	
	/**
	* Method which is in charge of performing Employee Search
	* @return PageReference
	*/
	public PageReference doSearch(){

		//set flags
		this.validSearch 	= false;
		this.firstEntry 	= false;
		this.tooMany 		= false;
		this.smallWord 		= false;
		this.internalError 	= false;
		this.manyResults 	= false;
		this.zeroResults 	= false;
		
		//set search term
		this.searchTerm = searchTerm;

		//parse search term into seperate words and check there will be not problems
		//for the SOSL statement
		if( ( searchTerm != null ) && ( !searchTerm.equals('') ) ){

			this.validSearch = true;
			this.searchWords = searchTerm.trim().split( '[\\s]++' );
			
			//put limit on number of words used
			if( this.searchWords.size() > 10 ){
				this.validSearch 	= false;
				this.tooMany 		= true;
			}
			
			//check words are long enough for SOSL, or it will error
			for( String i : this.searchWords ){
				
				String auxSearchTerm = i.replace( '*', '' );
				if( auxSearchTerm.length() <= 1 ){
					this.validSearch 	= false;
					this.smallWord 		= true;
				}
				
				if( i.length() <= 1 ){
					this.validSearch 	= false;
					this.smallWord 		= true;
				}

				if( ( i.length() == 2 ) && ( i.contains( '*' ) ) ){
					this.validSearch 	= false;
					this.smallWord 		= true;
				}
			}
		}
		else{
			this.searchWords = new String[]{};
			this.searchTerm 	= '';
			this.validSearch 	= false;
		}

		//run the SOSL
		this.findSearchedEmployees();
		
		//need to revist due to circular references
		//return Page.EmployeeDirectory;
		return ( new PageReference( '/apex/EmployeeDirectory' ) );
	}
		
	/**
	* add 'OR' word between the words and run the SOSL
	*/        
	public void findSearchedEmployees(){

		//check there are some valid search words
		//if no return an empty list
		if( this.validSearch == false ){
			this.searchResults = new List<Contact>();
			return;
		}

		List<List<SObject>> searchList = new List<List<SObject>>();

		try{
			//if here then we can do the search
			Boolean firstWord 	= true;
			String searchString = '';
		
			//build search string
			for( String i : searchwords ){
				if( !( i.equals( '' ) ) ){
					if( firstWord == true ){
						searchString 	= i;
						firstWord 		= false;
					}
					else{
						searchString = searchString + ' OR ' + i;
					}
				}
			}
			
			//find records
			searchList = [ FIND : searchString IN NAME FIELDS RETURNING Contact (Id, FirstName, LastName, Department, Email, Phone, MobilePhone, Fax 
								WHERE AccountId =: theAccount.id) limit 200 ];
							
			if( searchList.size() > 0 ){
				if( searchList[0].size()== 200 ){
					this.manyResults = true;
				}
	
				if( searchList[0].size()== 0 ){
					this.zeroResults = true;
				}
			}
		}
		catch( Exception e ){
			this.internalError = true;
		}
		
		this.searchResults = ( List<Contact> )searchList[0];
	}
}