public with sharing class MktpContentWrapper {
    /*******************************************************************************************
    @name           MktpContentWrapper
    @author      	Shankar Mallick
    @date      	    18 Novmber,2019
    @description:   This is the Content Wrapper Class
                    This wrapper class contains the AppListing Version Id
                    This wrapper class contains the list of Content Version records associated with the AppListing Version Id
                    This wrapper class contains the list of ContentDocumentLink records associated with the AppListing Version Id	
    **********************************************************************************************/
    
    @AuraEnabled public Id appId{get; set;}
    @AuraEnabled public List<ContentVersion> conVerList{get; set;}
    @AuraEnabled public List<ContentDocumentLink> cdlList{get; set;}
  
    public MktpContentWrapper() {
        conVerList = new List<ContentVersion>();
        cdlList = new List<ContentDocumentLink>();
    }
    
}