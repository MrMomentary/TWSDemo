/**
* This class implements all the Image Browser operations for the IPhone ©
* @author Guillermo Freire <guillermo.freire@gmail.com>
*/ 
public with sharing class imageBrowserController {

	
	/*
	 * Class properties
	 */
	//Search input field value
	public String recordName { get { return recordName ;} set { recordName = value ; } }
	
	//Select where to search value
	public String objectName { get { return objectName ;} set { objectName = value ; } }
	
	//Select what to show value
	public String showFilter {get;set;}	
	
	//Account search results
	public List<Account> searchResult { get { return searchResult; }  set{ searchResult = value;} }
	
	//Generic parameter ID for passing parameters
	public Id recordId { get { return recordId ;} set { recordId = value ; } }
	
	//Type of the element to display
	public String recordType { get{return recordType; } set{recordType = value;}}
	
	//Id of the image to display
	public Id imageId { get { return imageId ;} set { imageId = value ; } }
	 
	//Current Account been showed
	public Account targetObject { get {return targetObject; }  set { targetObject = value ; } }
	
	//Contacts of the last search
	public List<ContactExtension> relatedContacts { get {return relatedContacts; }  set { relatedContacts = value ; } }
	
	public SiteVisit__c siteVisit {get{return siteVisit;}set{siteVisit = value;}}
	
	/**
	* Constructor 
	*/
	public imageBrowserController(){		
		
		String q = System.currentPageReference().getParameters().get('q');
		if (q != null){
			recordName = q;
			objectName = 'Account';
			showFilter = 'SiteVisit';
			search();
			
		}
		/*
		String param = System.currentPageReference().getParameters().get('siteVisitId');
		if(param != null){
			
			siteVisit = [SELECT Id, Name, (SELECT Name, Id, ParentId, ContentType FROM Attachments where Name LIKE '%.jpg' OR Name LIKE '%.jpeg' OR Name LIKE '%.gif' ORDER BY LastModifiedDate DESC) FROM SiteVisit__c WHERE Id = :param];
			
		}	
			*/
	}	
	

	/**
	* Search method searches for the appropiate type of result and returns to corresponding page.
	* @return PageReference   
	*/ 
	public PageReference search(){
        
		objectName = String.escapeSingleQuotes(objectName);
		recordName = String.escapeSingleQuotes(recordName);  
		
		String qryString = '';
        
        if( objectName == 'Account' && showFilter == 'Contact' ){
            
            qryString = 'SELECT Id,Name,BillingCity FROM Account WHERE Name LIKE \'%' + recordName +
             			'%\' OR BillingCity LIKE \'%' + recordName + '%\' ORDER BY Name';     
            
            searchResult = Database.query(qryString) ;
            
            return Page.ImageBrowserAccountResults;
        }
       
        else if( objectName == 'Account' && showFilter == 'SiteVisit' ){
 			
        	qryString = 'SELECT Id,Name,BillingCity, (Select Id, Name, Longitude__c, Latitude__c From Site_Visits__r) FROM Account WHERE Name LIKE \'%' + recordName +
 				'%\' OR BillingCity LIKE \'%' + recordName + '%\' ORDER BY Name';          
        	
        	searchResult = Database.query(qryString) ;
        	
        	return Page.ImageBrowserSiteVisitResults;
        } 
         
        else if( objectName == 'Contact' ){
			qryString = 'SELECT Id, Name, Phone, AssistantName, ReportsTo.Name, (SELECT Name, Id, ParentId, ContentType FROM Attachments WHERE Name LIKE \'%.jpg\' OR Name LIKE \'%.jpeg\' OR Name LIKE \'%.gif\' ORDER BY LastModifiedDate DESC) FROM Contact WHERE Name LIKE \'%' + recordName +
         				'%\' OR Phone LIKE \'%' + recordName + '%\' ORDER BY Name';
			
			List<Contact> contacts = Database.query(qryString) ;
            relatedContacts = new List<ContactExtension>(); 
	 		for(Contact c : contacts){	 			
	 			relatedContacts.add(new ContactExtension(c));	 			
	 		}	
	 		
	 		return Page.ImageBrowserContactGallery;
        }
        else{
        	return null;
        }
        return null;
        
    } 
	
	
	/**
	* Returns the account's contacts to display its images.
	* @return PageReference   
	*/
	public PageReference viewThumbnails() {

 		targetObject = [SELECT Name, Id FROM Account WHERE Id = :recordId];
        
        List<Contact> contacts = [SELECT Id, Name, AssistantName, ReportsTo.Name, (SELECT Name, Id, ParentId, ContentType FROM Attachments where Name LIKE '%.jpg' OR Name LIKE '%.jpeg' OR Name LIKE '%.gif' ORDER BY LastModifiedDate DESC) FROM Contact WHERE (AccountId = :recordId) ORDER BY Name];
   
 		relatedContacts = new List<ContactExtension>(); 
 		for(Contact c : contacts){
 			relatedContacts.add(new ContactExtension(c));
 		}	

 		return Page.ImageBrowserAccountGallery;
    } 
	
	
	
	///////// SHOWING METHODS ////////////
	
	/**
	* Redirects to ImageBrowserAccountResults
	* @return PageReference   
	*/
    public PageReference backToImageSearchAccount() {
        
    	return Page.ImageBrowserAccountResults;    	

    } 
    
    /**
	* Redirects to ImageBrowserSiteVisitResults
	* @return PageReference   
	*/
    public PageReference backToImageSearchSiteVisit() {
        
    	return Page.ImageBrowserSiteVisitResults;

    }  	
    
    /**
	* Gets the information for the specificed Site Visit and redirects to ImageBrowserSiteVisitResults
	* @return PageReference   
	*/
    public PageReference viewSiteVisitThumbs(){
    
    	siteVisit = [Select s.Name, s.Id, s.Notes__c, s.Latitude__c, s.Longitude__c, (SELECT Name, Id, ParentId, ContentType FROM Attachments where Name LIKE '%.jpg' OR Name LIKE '%.jpeg' OR Name LIKE '%.gif' ORDER BY LastModifiedDate DESC) From SiteVisit__c s WHERE id= :recordId];
    	
    	return Page.ImageBrowserSiteVisitGallery;
    }
    
    /**
	* Redirects to ImageBrowserSearch
	* @return PageReference   
	*/
    public PageReference backToImageSearch(){
    	
    	return Page.ImageBrowserSearch;
    	
    }
	
	/////////// ACCESSORY CLASSES ///////////////////	
	
	/**
	 * @author Guillermo Freire
	 */ 
	public class ContactExtension{
		
		/*
		 * Class properties
		 */
		public Contact reportsTo { get{ return this.c.reportsTo; }}
		public String AssistantName { get{ return this.c.AssistantName; }}
		public Boolean hasAttachments { get { return !this.c.Attachments.isEmpty(); }}
		public List<Attachment> Attachments { get{ return this.c.Attachments;}}
		public String Name  { get { return this.c.Name;}}
		public Id Id  { get { return this.c.Id;}}
		private Contact c;
		
		/**
		 * Constructor 
	     */
		public ContactExtension(Contact c ){
			this.c = c;
		}		
	}
}