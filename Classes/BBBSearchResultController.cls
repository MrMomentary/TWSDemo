public with sharing class BBBSearchResultController {
	
	public Boolean showGalleryResult { get; set; }
	public Boolean showStringResult { get; set; }
	public Boolean showSiteVisitResult {get;set;}
	
	public String recordName {get;set;}
	public String objectName {get;set;}
	public String showFilter{get;set;}
	
	public String getFilter(){
		return showFilter;
	}
	
	public String getSearchTerm(){
		return recordName;
	}
	
	public List<StringSearchResult> StrResultList { get; set; }
	public List<GallerySearchResult> GalleryResultList { get; set; }
	
	public BBBSearchResultController(){
	
		objectName = System.currentPageReference().getParameters().get('obj');
		recordName = System.currentPageReference().getParameters().get('searchTerm');
		showFilter = System.currentPageReference().getParameters().get('filter');
		showSiteVisitResult = false;
		
		doSearchQuery();	
	}
	
	public void doSearchQuery(){
		 
		String qryString = '';
		List<Account> AccountResult = new List<Account>();
		List<Contact> ContactResult = new List<Contact>();
		 
		if( objectName == 'Account' && showFilter == 'Contact' ){
            
            qryString = 'SELECT Id,Name,BillingCity FROM Account WHERE Name LIKE \'%' + recordName +
             			'%\' OR BillingCity LIKE \'%' + recordName + '%\' ORDER BY Name';     
            
            AccountResult =  Database.query(qryString);
            showStringResult = true;
            
            // Build de result list
            StrResultList = new List<StringSearchResult>();
        	
        	for(Account a: AccountResult){	        	
	        	StrResultList.add(new StringSearchResult(a.Id, a.Name, a.BillingCity));
	        }	
        } 
        else if( objectName == 'Account' && showFilter == 'SiteVisit' ){
 			
       
        	qryString = 'SELECT Id,Name,BillingCity, (Select Id, Name, Longitude__c, Latitude__c From Site_Visits__r) FROM Account WHERE Name LIKE \'%' + recordName +
 				'%\' OR BillingCity LIKE \'%' + recordName + '%\' ORDER BY Name';          
        	
        	AccountResult = Database.query(qryString);        	
        	showSiteVisitResult = true;
        	
        	// Build de result list
            StrResultList = new List<StringSearchResult>();
        	
        	for(Account a: AccountResult){	     
        		StringSearchResult ssr = new StringSearchResult(a.Id, a.Name, a.BillingCity);
        		ssr.siteVisits = a.Site_Visits__r;
	        	StrResultList.add(ssr);
	        }	
        	
        } 
        else if( objectName == 'Contact' ){
			
			
			qryString = 'SELECT Id, Name, Phone, AssistantName, ReportsTo.Name, (SELECT Name, Id, ParentId, ContentType FROM Attachments WHERE Name LIKE \'%.jpg\' OR Name LIKE \'%.jpeg\' OR Name LIKE \'%.gif\' ORDER BY LastModifiedDate DESC) FROM Contact WHERE Name LIKE \'%' + recordName +
         				'%\' OR Phone LIKE \'%' + recordName + '%\' ORDER BY Name';
			
			ContactResult = Database.query(qryString) ;
            
            showGalleryResult = true;
            
            // Build de result list
            GalleryResultList = new List<GallerySearchResult>();
        	
        	for(Contact c: ContactResult){	
        		
        		GallerySearchResult galResult = new GallerySearchResult(c.Id, c.Name, null, c.Attachments);
        		If(c.ReportsTo.Name != null)
        		{
        			galResult.ReportsTo = c.ReportsTo.Name;	
        		}
        		If(c.AssistantName != null)
        		{         			
        			galResult.Assistant = c.AssistantName;
        		}          		
	        	GalleryResultList.add(galResult);
	        }	
            
        } 
    }
	
		
	// String Results
	public class StringSearchResult {
		
		public StringSearchResult(String sId, String sCol1, String sCol2){
			this.Id = sId; 
			this.Col1 = sCol1;
			this.Col2 = sCol2;
			siteVisits = new List<SiteVisit__c>{}; 
		}
		
		public List<SiteVisit__c>siteVisits{get;set;}
		
		public String Id { get; set; }
		public String Col1 { get; set; }
		public String Col2 { get; set; }		
	}
	
}