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
 1.0		29-10-2008		Mark Sivill		Initial version
*/

/**
* Trigger to ensure only one record is added to the configuration object
*/
public with sharing class Employee_Directory_Configuration{

	/**
	* Do counts on records before making changes to database
	* @param edcs
	*/
	public static void checkOneRecordBefore( List<Employee_Directory_Configuration__c> edcs ){
		
		Boolean isValid = true; 

		// check if batch size is getter than one, if so error
		if ( edcs.size() > 1 ){	
			isValid = false;	
		}
		else{
			// see if there is an existing record, if so error
			List<Employee_Directory_Configuration__c> edc = [ SELECT id FROM Employee_Directory_Configuration__c LIMIT 1 ];

			if( edc.size() == 1 ){
				isValid = false;
			}
		}
	
		if( isValid == false ){
			for( Employee_Directory_Configuration__c i : edcs ){
				i.addError( 'Only one record is allowed for this object' );
			}
		}
	}

	/**
	* Do counts on records before after changes to database, no before undelete so need slightly different logic
	* @param edcs
	*/
	public static void checkOneRecordAfter( List<Employee_Directory_Configuration__c> edcs ){
		
		Boolean isValid = true; 

		//check if batch size is getter than one, if so error
		if ( edcs.size() > 1 ){	
			isValid = false;	
		}
		else{
			//see if there is more than one record now, if so error
			List<Employee_Directory_Configuration__c> edc = [ SELECT id FROM Employee_Directory_Configuration__c LIMIT 2 ];

			if( edc.size() > 1 ){
				isValid = false;
			}
		}
	
		if( isValid == false ){
			for( Employee_Directory_Configuration__c i : edcs ){
				i.addError( 'Only one record is allowed for this object' );
			}
		}
	}
}