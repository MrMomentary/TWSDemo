public with sharing class BBBAddSiteVisitController {
	
	// Params
	public String PARENTID; 
	public String isNewInsert;
	
	// form fields
	public String siteVisitName;
	public String siteVisitNotes;
	public String siteVisitLatitude;
	public String siteVisitLongitude;
	
	public String st{get;set;} 
	
	// Site visit
	public SiteVisit__c sv { get; set; }
	public String getParentId(){
		return PARENTID;
	}
	
	// booleans to show  / hide
	public Boolean showForm { get; set ;}
	public Boolean showSuccessMessage { get; set ;}
	
	// validation
	public Boolean showMessage { get; set; }	
	public String opMessage { get; set; }	
	
	// Constructor
	public BBBAddSiteVisitController(){
		
		showForm = true;
		showSuccessMessage = false;
		showMessage = false;
		opMessage = '';
		Map<String,String> params = System.currentPageReference().getParameters();
		
		st = params.get('st');
		PARENTID = params.get('id');
		isNewInsert = params.get('addingSiteVisit');
		siteVisitName = params.get('siteVisitName');
		siteVisitNotes = params.get('siteVisitNotes');
		siteVisitLatitude = params.get('siteVisitLatitude');
		siteVisitLongitude = params.get('siteVisitLongitude');
	}
	
	// Check and save 
	public void checkAndSave(){
		if(isNewInsert != null){
			save();
		}
	}
	
	// Save method
	public void save(){
		
		
		if(ImageBrowserUtil.isCSRF(Page.BBBSearchResult)){
			showMessage = true;
			opMessage = 'ERROR: The operation could not be completed';
			return;
		}
		
		sv = new SiteVisit__c();			
		
		// Select s.Notes__c, s.Name, s.Longitude__c, s.Latitude__c, s.Case__c, s.Account__c From SiteVisit__c s
		String parentPrefix = PARENTID.substring(0,3);		
		
		if(parentPrefix == '001'){
			sv.Account__c = PARENTID;
		} else {
			sv.Case__c = PARENTID; 
		}
		
		sv.Name = siteVisitName;
		sv.Notes__c = siteVisitNotes;
		sv.Latitude__c = siteVisitLatitude;
		sv.Longitude__c = siteVisitLongitude;
		
		try {
			insert sv;
			showForm = false;
			showSuccessMessage = true; 
			
		} catch (Exception e){
			showMessage = true;
			opMessage = 'ERROR: All fields must be filled in!';					
		}		
	}
}