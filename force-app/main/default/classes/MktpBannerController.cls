public with sharing class MktpBannerController {
    /*******************************************************************************************
    @author      	Shankar Mallick
    @date      	    06 Novmber,2019
    @description:   This controller is to fetch Banner Details to display on the HomePage
    Revision(s):	
                  
    **********************************************************************************************/


    /*******************************************************************************
    @method         getActiveBanner
    @author 	    Shankar Mallick
    @date      	    06 Nov,2019
    @param	    
    @return		    List<AppBanner__c>
    @description	Controller method to get the currently active Banner
    *******************************************************************************/

    @AuraEnabled(cacheable = true)
    public static List<AppBanner__c> getActiveBanner() {
        return [SELECT Id, Name, Description__c, ImageAlternativeText__c, ImagePath__c, DisplayEndDate__c, DisplayStartDate__c FROM AppBanner__c WHERE  Active__c  = True LIMIT 1];
    }
}