public without sharing class mktp_newApplicationsController {
    public mktp_newApplicationsController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<MktpPublishedAppWrapper> mktp_fetchNewApps(){

        set<Id> newAppsRecId = new Set<Id>();
        List<MktpPublishedAppWrapper> pubWrapperList = new List<MktpPublishedAppWrapper>();

        // Loop through the list to generate a set of Published Apps
        for (AppRecommendation__c recommendedAppRecord : [select AppLogo__c, Name, PublishedApp__c FROM AppRecommendation__c 
                                                            WHERE RecommendationType__c	= 'New Recommendation' 
                                                            ORDER BY RecommendationOrder__c NULLS LAST])
        {
            newAppsRecId.add(recommendedAppRecord.PublishedApp__c);
        }

        System.debug('new app size: ' +newAppsRecId.size());
        if(newAppsRecId.size()>0){
            pubWrapperList = mktpPublishedAppSearchController.getPublishedAppWrapper(newAppsRecId);
        }

         System.debug('new app wrapper size: ' +pubWrapperList.size());
        return pubWrapperList ;

        /*return [select AppLogo__c, Name,CalculatedRating__c,TagLine__c,PublishedApp__c,PublishedDate__c 
        from AppRecommendation__c where RecommendationType__c = 'New Recommendation'
        order by RecommendationOrder__c asc limit 10
        ];*/
    }
}