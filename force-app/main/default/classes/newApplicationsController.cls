public with sharing class newApplicationsController {
    public newApplicationsController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<AppRecommendation__c> fetchNewApps(){
        return [select AppLogo__c, Name,CalculatedRating__c,TagLine__c,PublishedApp__c,PublishedDate__c 
        from AppRecommendation__c
        ];
    }
}