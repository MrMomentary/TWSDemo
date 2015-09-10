@isTest private class GallerySearchResultTest {

    static testMethod void run() {
    	
    	List<Attachment> atts = new List<Attachment>{}; 
        GallerySearchResult g = new GallerySearchResult('blah', 'blah', 'blah', atts);
        Boolean b = g.haveAttachments;
        List<Attachment> photos = g.photos;
        String Name = g.Name;
        String Description = g.Description;
        String ItemId = g.ItemId;
    }
}