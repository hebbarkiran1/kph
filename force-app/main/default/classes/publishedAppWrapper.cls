public with sharing class publishedAppWrapper {
    /*******************************************************************************************
    @name           publishedAppWrapper
    @author      	Shankar Mallick
    @date      	    06 Novmber,2019
    @description:   This is the PublishedApp Wrapper Class
                    This wrapper class contains the properties for the Published App and two Lists.
                    One List is for the features and the other is for the Categories	
    **********************************************************************************************/
    @AuraEnabled public Id appId{get; set;}
    @AuraEnabled public String cardTitle{get; set;}
    @AuraEnabled public Boolean freeApp{get; set;}
    @AuraEnabled public PublishedApp__c app{get; set;}
    @AuraEnabled public List<AppCategory__c> appCategoryList{get; set;}
    @AuraEnabled public List<AppFeature__c> appFeatureList{get; set;}
    
    public publishedAppWrapper() {
        appCategoryList = new List<AppCategory__c>();
        appFeatureList = new List<AppFeature__c>();
    }
}