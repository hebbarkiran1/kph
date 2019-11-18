public with sharing class MktpMarketingContent {
    /*******************************************************************************************
    @name           MktpMarketingContent
    @author      	Shankar Mallick
    @date      	    18 Novmber,2019
    @description:   This is the Marketing Content Class
                    This class supports multiple methods related to the Marketing Content
                    One List is for the features and the other is for the Categories	
    **********************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static MktpContentWrapper getMarketingContent(Id appListingVersionId) {
        // Declare the variable here
        MktpContentWrapper conwrapperRecord = new MktpContentWrapper();
        Set<Id> cdIdSet = new Set<Id>();
        List<ContentVersion> cvList = new List<ContentVersion>();
        List<ContentDocumentLink>  cdlList = new List<ContentDocumentLink>();
        
        // Add the AppListingVersionId to the appId
        conwrapperRecord.appId = appListingVersionId;
        // Get the List of ContentDocumentLink based on appListingVersionId
        cdlList = [Select Id, ContentDocumentId, LinkedEntityId, ShareType, Visibility FROM ContentDocumentLink WHERE LinkedEntityId = : appListingVersionId ];
        // Add the cdlList to the conwrapperRecord.cdlList
        conwrapperRecord.cdlList = cdlList;
        System.debug('cdlList :: ' + cdlList);
        
        // Generate the cdIdSet from the ddlList
        for(ContentDocumentLink cdlRecord : cdlList ){
            cdIdSet.add(cdlRecord.ContentDocumentId);
        }
        // Generate the cvList and associate with conwrapperRecord
        if(cdIdSet.size()>0){
            cvList = [Select Id, Title, Description, ContentDocumentId, FileType, FileExtension, isMajorVersion, OwnerId, PathOnClient, TextPreview, VersionData, DocumentType__c, ContentLocation, ContentType__c FROM ContentVersion where ContentDocumentId IN : cdIdSet ];
            conwrapperRecord.conVerList = cvList;
            System.debug('cvList :: ' + cvList);
        }
        System.debug('cdlLconwrapperRecordist :: ' + conwrapperRecord);
        return conwrapperRecord;
    }




    @AuraEnabled()
    public static void insertMarketingContent(Id appListingVersionId, List<MktpContentWrapper> conwrapperList ) {

    }

    private static ContentVersion createContentVersion(String base64, String fileName, String contentType, String docType) {
    ContentVersion cvRecord = new ContentVersion();
    cvRecord.VersionData = EncodingUtil.base64Decode(base64);
    cvRecord.Title = fileName;
    cvRecord.Description = fileName;
    cvRecord.PathOnClient = fileName;
    cvRecord.ContentType__c = contentType;
    cvRecord.DocumentType__c = docType;
    try {
        insert cvRecord;
        return cvRecord;
    } catch(DMLException e) {
        System.debug(e);
        return null;
    }
  }

    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [ SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        // ShareType is either 'V', 'C', or 'I'
        // V = Viewer, C = Collaborator, I = Inferred
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }

}