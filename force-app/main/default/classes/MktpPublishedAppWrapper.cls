public with sharing class MktpPublishedAppWrapper {
    
    /*******************************************************************************************
    @name           MktpPublishedAppWrapper
    @author      	Shankar Mallick
    @date      	    06 Novmber,2019
    @description:   This is the PublishedApp Wrapper Class
                    This wrapper class contains the properties for the Published App and two Lists.
                    One List is for the features and the other is for the Categories	
    **********************************************************************************************/
    
    @AuraEnabled public Id appId{get; set;}
    @AuraEnabled public String appTitle{get; set;}
    @AuraEnabled public String appStatus {get;set;}
    @AuraEnabled public String appReleaseVersion {get;set;}
    @AuraEnabled public string tagLine {get;set;}

    @AuraEnabled public string publishedBy {get;set;}
    @AuraEnabled public string publishedDate {get;set;}
    @AuraEnabled public string rating {get;set;}
    @AuraEnabled public string installURL {get;set;}
    @AuraEnabled public string appBannerURL {get;set;}
    @AuraEnabled public string logoURL {get;set;}
    

    @AuraEnabled public List<String> pricing {get;set;}
    @AuraEnabled public List<String> supportedOS {get;set;}
    @AuraEnabled public List<String> supportedLang {get;set;}
    @AuraEnabled public List<String> categories {get;set;}
    
    // @AuraEnabled public Boolean isFreeOrPaidApp {get;set;}
    // @AuraEnabled public PublishedApp__c app{get; set;}
    // @AuraEnabled public AppFeature__c appFeature{get; set;}

    //     @AuraEnabled public String cardTitle{get; set;}

    // @AuraEnabled public List<AppCategory__c> appCategoryList{get; set;}
    // @AuraEnabled public List<AppFeature__c> appFeatureList{get; set;}
    
     public MktpPublishedAppWrapper() {
        // appCategoryList = new List<AppCategory__c>();
        // appFeatureList = new List<AppFeature__c>();

        pricing = new List<String>();
        supportedOS = new List<String>();
        supportedLang = new List<String>();
        categories = new List<String>();
    }
}