public without sharing class RecommendedAppsController {
    /*******************************************************************************************
        @author         Anirudh Bandi
        @date           07 Novmber,2019
        @description:   This controller is to fetch recommended apps to display on the HomePage
        Revision(s):  
    **********************************************************************************************/
    public RecommendedAppsController() {

    }
    /*******************************************************************************
    @method         fetchRecApps
    @author         Anirudh Bandi
    @date           07 Nov,2019
    @param      
    @return        List<AppRecommendation__c>
    @description  Controller method to get the currently active Banner
    *******************************************************************************/
@AuraEnabled(cacheable=true)
    public static List<MktpPublishedAppWrapper> fetchRecApps(){

        set<Id> recAppsRecId = new Set<Id>();
        List<MktpPublishedAppWrapper> pubWrapperList = new List<MktpPublishedAppWrapper>();

        // Loop through the list to generate a set of Published Apps
        for (AppRecommendation__c recommendedAppRecord : [select AppLogo__c, Name, PublishedApp__c FROM AppRecommendation__c 
                                                            WHERE RecommendationType__c	= 'Top Recommendation' 
                                                            ORDER BY RecommendationOrder__c NULLS LAST])
        {
            recAppsRecId.add(recommendedAppRecord.PublishedApp__c);
        }

        //System.debug('rec app size: ' +recAppsRecId.size());
        if(recAppsRecId.size()>0){
            pubWrapperList = mktpPublishedAppSearchController.getPublishedAppWrapper(recAppsRecId);
        }

         //System.debug('rec app wrapper size: ' +pubWrapperList.size());
        return pubWrapperList ;

        /*return [select AppLogo__c, Name,CalculatedRating__c,TagLine__c,PublishedApp__c,PublishedDate__c 
        from AppRecommendation__c where RecommendationType__c = 'New Recommendation'
        order by RecommendationOrder__c asc limit 10
        ];*/
    }
}