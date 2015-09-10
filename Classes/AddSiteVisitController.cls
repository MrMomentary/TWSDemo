public with sharing class AddSiteVisitController {
	
	public String PARENTID = System.currentPageReference().getParameters().get('id');
	
	public Boolean showMessage { get; set; }
	public String opMessage { get; set; }	
	
	public PageReference goBack{get{return new PageReference(Page.imagebrowsersitevisitresults.getUrl()+'?q='+q);}}
	
	public SiteVisit__c sv {set;get;}
	
	//Query string from where it came
	public String q {get;set;}
	
	public AddSiteVisitController(){
		showMessage = false;
		opMessage = '';	
		sv = new SiteVisit__c();
		q = System.currentPageReference().getParameters().get('q');
		
	}
	
	public PageReference save(){
		
		// Select s.Notes__c, s.Name, s.Longitude__c, s.Latitude__c, s.Case__c, s.Account__c From SiteVisit__c s
		
		String parentPrefix = PARENTID.substring(0,3);		
		if(parentPrefix == '001'){
			sv.Account__c = PARENTID;
		} else {
			sv.Case__c = PARENTID; 
		}
		
		try {
			insert sv;
			
		} catch (Exception e){
			showMessage = true;
			opMessage = 'An error was found!!';
			delete sv;
			return null;
		}		
		
		showMessage = true;
		opMessage = 'Success , Sitevisit Added!';
		return new PageReference(Page.imagebrowsersitevisitresults.getUrl()+'?q='+q);
		
	}
	
	public PageReference cancel(){
		return new PageReference(Page.imagebrowsersitevisitresults.getUrl()+'?q='+q);
	}
}