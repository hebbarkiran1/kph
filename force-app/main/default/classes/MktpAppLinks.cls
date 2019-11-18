public without sharing class MktpAppLinks {
    /*******************************************************************************************
    @name           mktpAppLinks
    @author      	Shankar Mallick
    @date      	    06 Novmber,2019
    @description:   This controller is used to view App Links Data
    Revision(s):	
                  
    **********************************************************************************************/
    @AuraEnabled(cacheable = true)
    public static List<AppLinks__c> viewHomePageAppLinks() {
        return [Select Id, Name, Label__c, PageAPIName__c, PageName__c, Title__c, Type__c, IconName__c FROM AppLinks__c WHERE Active__c = true];
    }
        // List all the homepage links that are active 
    @AuraEnabled(cacheable = true)
    public static List<AppLinks__c> viewSearchResultLinksPublishedApp(){
        return [Select Id, Name, Label__c, PageAPIName__c, PageName__c, Title__c, Type__c, IconName__c FROM AppLinks__c WHERE Active__c = true AND Type__c = 'Homepage'];
    }
    
}