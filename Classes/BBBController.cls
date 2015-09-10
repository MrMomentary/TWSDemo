/**
 * Developed by Timba Software Corp. www.timbasoftware.com admin@timbasoftware.com
 * @author Guillermo Freire <guillermo.freire@gmail.com>
 */
 public virtual class BBBController {

	public Boolean redirect{get;set;}
	public String redirectionUrl{get;set;}
	protected Map<String,String> params;
	protected String paramsString{get{return getParamsString();}}
	
	public BBBController(){	
		getParameters();	
	}
	
	public void getParameters(){
	
		if (System.currentPageReference() != null){
			params = System.currentPageReference().getParameters();
		}	
		else{
			params = new Map<String,String>();
		}
	}
	
	public string getLinkTo(PageReference page){
		return page.getUrl()+'?'+paramsString;
	}
	
	public void setRedirect(PageReference page)
	{
		redirect = true;
		redirectionUrl = getLinkTo(page);
	}
	
	public Boolean isEvent(String eventName){
	
		return params.containsKey(eventName);
	}
	
	public string getParamsString(){
		string s = '';
		for(String key : params.keySet()){		
			s = s + '&' + key + '=' + params.get(key);		
		}
		if(s.length()==0){
			return s;
		}
		return s.substring(1);
	}
}