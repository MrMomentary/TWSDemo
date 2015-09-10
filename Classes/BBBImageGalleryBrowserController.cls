public with sharing class BBBImageGalleryBrowserController {
	
	public String objectId{get;set;}
	public String showFilter{get;set;}
	public String oldSearchTerm{get;set;}
	public String objectName{get;set;}
	public String getSearchTerm(){
		return oldSearchTerm;
	}
	
	public String qryString { get; set; }
	
	public Boolean isSiteVisit { get; set; }
	
	public List<GallerySearchResult> GalleryResultList { get; set; }
	public SiteVisit__c SiteVisitResult { get; set; }
	public List<Contact> ContactResult { get; set; }
	
	public String objTitle {get;set;}
	
	public BBBImageGalleryBrowserController(){
		
		showFilter = System.currentPageReference().getParameters().get('filter');
		
		if (showFilter == 'SiteVisit'){
			objTitle = 'Site Visit Details';
		} 
		else if (showFilter == 'Contact'){
			objTitle = 'Contact Image Browser'; 
		}
		else{		
			objTitle = 'Contact Image Browser';
		}
		
		oldSearchTerm = System.currentPageReference().getParameters().get('st');
		objectId = System.currentPageReference().getParameters().get('id');
		objectName = System.currentPageReference().getParameters().get('obj');
		String s = System.currentPageReference().getParameters().get('isSV');		
		
		// Initialize
		isSiteVisit = false;
		if (s != null){
			isSiteVisit = true;
		}
        qryString = '';
        GalleryResultList = new List<GallerySearchResult>();
        
        // Get the photos    
		showGalleryResults();
	}
	
	public void showGalleryResults(){		
		
		 
		if( showFilter == 'Contact' ){
          
            String jpgExt = '%.jpg';
            String jpegExt = '%.jpeg';
            String gifExt = '%.gif';
            
            ContactResult = [Select 
				            	c.Id, 
				            	c.Name, 
				            	c.Description, 
				            	c.AccountId,
				            	c.AssistantName, 
				            	c.ReportsTo.Name,
				            	(Select Id,  Name, ContentType From Attachments 
				            	where Name LIKE :jpgExt  OR Name LIKE :jpegExt OR Name LIKE :gifExt ORDER BY LastModifiedDate DESC) 
				            	From Contact c where c.AccountId =: objectId order by Name];
            
            
        	
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
        else if( showFilter == 'SiteVisit' ){
 			
 			isSiteVisit = true;
 			SiteVisitResult = [Select s.Name, s.Id, s.Notes__c, s.Latitude__c, s.Longitude__c, (SELECT Name, Id, ParentId, ContentType FROM Attachments where Name LIKE '%.jpg' OR Name LIKE '%.jpeg' OR Name LIKE '%.gif' ORDER BY LastModifiedDate DESC) From SiteVisit__c s WHERE id= :objectId];
 			if(SiteVisitResult != null){
	 			GallerySearchResult sv = new GallerySearchResult(SiteVisitResult.Id, SiteVisitResult.Name, SiteVisitResult.Notes__c, SiteVisitResult.Attachments);
	 			sv.Lat = SiteVisitResult.Latitude__c;
	 			sv.Lon = SiteVisitResult.Longitude__c;
	 			GalleryResultList = new List<GallerySearchResult>{sv};
 			}
 			else{
 				GalleryResultList = new List<GallerySearchResult>();
 			} 			
        }		
	}
}