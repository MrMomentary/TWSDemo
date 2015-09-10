public with sharing class BBBImageCaptureController {

	public String OBJ_PARENTID = System.currentPageReference().getParameters().get('id');
	public String OBJ_ID = System.currentPageReference().getParameters().get('objId');
	
	// get the last search term.
	public String oldTerm = System.currentPageReference().getParameters().get('st');
	public String objectName = System.currentPageReference().getParameters().get('obj');
	public String showFilter = System.currentPageReference().getParameters().get('filter');
	
    public Attachment newAttachment {get;set;}
  	public Boolean uploadError { get; set; }
  	public Boolean redirectToSearchResult { get; set; }
  	public String errorMessage { get; set; }
  	public string backUrl{get;set;}
  	
  	public String filter { get; set; }
  	
  	public String getParentId(){
  		return OBJ_ID;
  	}
  	
 	public BBBImageCaptureController() {
 		
 		uploadError = false;
        errorMessage = '';
        redirectToSearchResult = false;
        
 		newAttachment = new Attachment();
 		
 		
 		if(OBJ_PARENTID == null){ 
 			
 			redirectToSearchResult = true;
 			//uploadError = true; 
        	//errorMessage = 'The parent object Id is missing.';
 		
 		} else {
 			String parentPrefix = OBJ_PARENTID.substring(0,3); 			 
 			if(parentPrefix != 'a0C'){
 				filter = 'Contact';
 			} else {
 				filter = 'SiteVisit';
 			}
 		}
 		
 		if(OBJ_ID != null){
			backUrl = Page.BBBImageGalleryBrowser.getUrl()+'?id=' + OBJ_ID + '&filter=' + showFilter + '&obj=' + objectName + '&st=' + oldTerm;
		}else{
			backUrl = Page.BBBSearchResult.getUrl()+'?searchTerm='+ oldTerm +'&obj='+objectName+'&filter=' + showFilter;
		}   
 	}
 	
 	
    public PageReference step1() {
    	
  		newAttachment = new Attachment();
  		return Page.BBBImageCapture;
    }

    
    // This method performs the final save and then
    // navigates the user to the detail page for the new Image record.
    public PageReference save() {
       	
       	newAttachment.parentid = OBJ_PARENTID;
    	
        try {
        	insert newAttachment;
        } Catch (Exception e){
        	uploadError = true;
        	errorMessage = 'An error was found during the upload of the file, please try again.';
        	return null;
        } 
             
		return new PageReference(backUrl);		    
    }

}