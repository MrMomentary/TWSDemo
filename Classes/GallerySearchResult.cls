public with sharing class GallerySearchResult {
	
	public GallerySearchResult(String Id, String sName, String sDesc, List<Attachment> atts){
			this.ItemId = Id;
			this.Name = sName;
			this.Description = sDesc;
			this.photos = atts;
			this.haveAttachments = false;
			if((this.photos).size() > 0 ){
				this.haveAttachments = true;
			}
			this.isSiteVisit = 'false';
		}
		
	public Boolean haveAttachments { get; set;}
	public List<Attachment> photos { get; set; }
	public String Name { get; set; }
	public String Description { get;set; }
	public String ItemId { get; set; }
	public String isSiteVisit {get;set;}
	public String Lat {get;set;}
	public String Lon {get;set;}
	public String ReportsTo {get;set;}
	public String Assistant {get;set;}
			
}