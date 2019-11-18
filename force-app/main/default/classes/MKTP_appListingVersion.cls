public with sharing class MKTP_appListingVersion {

    @AuraEnabled(cacheable = true)  
    public static void MKTP_cloneNewAppListingVersion(Id appListingVersionId,  String newVersionName) {
        
        // Declaring  the variables
        //List<AppListingVersion__c> newAppVersionList = new List<AppListingVersion__c>();
        AppListingVersion__c currentAppVersionRecord = [SELECT Id, AppListing__c, Architecture__c, Banner__c, BusinessOverview__c, Highlights__c,InstallURL__c FROM AppListingVersion__c WHERE Id = : appListingVersionId ];
        AppListingVersion__c newAppVersionRecord = currentAppVersionRecord.clone(false, true, false,false);
        newAppVersionRecord.Name = newVersionName;
        insert newAppVersionRecord;    
    }

    // List all the published apps 
    @AuraEnabled(cacheable = true)
    public static List<PublishedApp__c> MKTP_getPublishedApp(){
        return [SELECT Id, Name, AppListingVersion__c, AppListing__c, TagLine__c, ShortDescription__c, Publisher__c, PublisherType__c,  PublishDate__c, OwnerId, PublishStatus__c FROM PublishedApp__c WHERE  PublishStatus__c = 'Active'];
    }

    @AuraEnabled(cacheable = true)
    public static List<AppListingVersion__c> MKTP_getAppListingVersion(){
        return [SELECT Id, Name, AppName__c, AppListing__c, TagLine__c, Architecture__c, Banner__c, BusinessOverview__c, Highlights__c,InstallURL__c, ListingStatus__c, PublishStatus__c, Publisher__c, ShortDescription__c FROM AppListingVersion__c];
    }
}