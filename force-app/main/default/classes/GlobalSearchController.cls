public with sharing class GlobalSearchController {
    public GlobalSearchController() {

    }
    /* SM: commenting to remove the Object App_REviews__c
    @AuraEnabled(cacheable=true)
     public static List<App_Reviews__c>  retrieveAllTags(String publishedAppId) {
        return [SELECT Search_Tags__c,Id,Published_App_ID__c  FROM App_Reviews__c WHERE Published_App_ID__c =: publishedAppId];
    }

     @AuraEnabled(cacheable=true)
     public static List<PublishedApp__c>  tagSearchResultList(String searchTag) {
        String tagsToSearch = '%'+searchTag+'%';
        List<PublishedApp__c> similarPublishedApps = new List<PublishedApp__c>();
        Set<Id> publishedAppIds = new Set<Id>();

        for(App_Reviews__c appR : [select Published_App_ID__c  from App_Reviews__c where Search_Tags__c LIKE: tagsToSearch]){
            publishedAppIds.add(appR.Published_App_ID__c);
        }
        if(!publishedAppIds.isEmpty()){
            similarPublishedApps = [SELECT Id , Name FROM PublishedApp__c WHERE Id IN:publishedAppIds];
        }
        return similarPublishedApps;
    }
    SM: End of Commenting */
}