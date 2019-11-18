public with sharing class MktpAppListingVersion {
    /*******************************************************************************************
    @name           MktpAppListingVersion
    @author      	Shankar Mallick
    @date      	    06 Novmber,2019
    @description:   This controller is to fetch, update, clone AppListingVersion Data
    Revision(s):	
                  
    **********************************************************************************************/

    /********************************
        //Clone an existing old AppListingVersion Record that has already been published
        @method name    : cloneNewAppListingVersion
        @param1         : newVersionName
        @param2         : appListingVersionId
        @author      	Shankar Mallick
        @date      	    06 Novmber,2019
    ***********************************/
    @AuraEnabled
    public static void cloneNewAppListingVersion(Id appListingVersionId,  String newVersionName) {
        try{
            Logger.push('MktpAppListingVersion', 'cloneNewAppListingVersion');
            // Loggin the input parameters
            Logger.debug(' input paramter 1: appListingVersionId :: ' + appListingVersionId);
            Logger.debug(' input parameter 2: newVersionName :: ' + newVersionName);

            if (String.isBlank(appListingVersionId) || String.isBlank(newVersionName) ) {
                Logger.debug('either the record id is blank or the version name is blank');
                //throwException('Either the Record Id is blank or New Version Name is Blank');
            } else {
                //Logger.push('MktpAppListingVersion', 'cloneNewAppListingVersion');
                
                
                // Declaring  the variables
                Id newAppListingVersionId;
                // Get the RecordTypeId for 'Draft AppListing'
                Id draftRecordTypeId = Schema.SObjectType.AppListingVersion__c.getRecordTypeInfosByName().get('Draft AppListing').getRecordTypeId();
                Logger.debug(' draftRecordTypeId :: ' + draftRecordTypeId);
                
                //List<AppListingVersion__c> newAppVersionList = new List<AppListingVersion__c>();
                AppListingVersion__c currentAppVersionRecord = [SELECT Id, Name,  AppListing__c, AboutPublisher__c, AppOwner__c, Architecture__c, Banner__c, BusinessOverview__c, Highlights__c,InstallURL__c, ListingStatus__c, Logo__c, LongDescription__c, PublishStatus__c, Publisher__c, PublisherType__c, RecordTypeId, ShortDescription__c, TagLine__c, TechnicalOverview__c FROM AppListingVersion__c WHERE Id = : appListingVersionId ];
                AppListingVersion__c newAppVersionRecord = currentAppVersionRecord.clone(false, true, false,false);
                newAppVersionRecord.Name = newVersionName;
                newAppVersionRecord.ListingStatus__c = 'Created';  
                newAppVersionRecord.PublishStatus__c = 'Draft';
                newAppVersionRecord.RecordTypeId = draftRecordTypeId;
                insert newAppVersionRecord;
                newAppListingVersionId =  newAppVersionRecord.Id;

                Logger.debug('newAppListingVersionId :: ' + newAppListingVersionId);
                
                
                // Call the cloneAppVersion methods to create the cloned child records
                cloneAppVersionCategory(newAppListingVersionId, appListingVersionId);
                cloneAppVersionFeature(newAppListingVersionId, appListingVersionId);
                cloneAppVersionRequirement(newAppListingVersionId, appListingVersionId);
                cloneAppVersionIndustry(newAppListingVersionId, appListingVersionId);
            }     
        }
        catch(Exception ex) {
            Logger.debugException(ex);
            //throw new AuraHandledException(ex.getMessage());
        }
        finally{
            Logger.pop();
        }
        
    }

    // List all the published apps 
    @AuraEnabled(cacheable = true)
    public static List<PublishedApp__c> getPublishedApp(){
        return [SELECT Id, Name, AppListingVersion__c, AppListing__c, TagLine__c, ShortDescription__c, Publisher__c, PublisherType__c,  PublishDate__c, OwnerId, PublishStatus__c FROM PublishedApp__c WHERE  PublishStatus__c = 'Active'];
    }
    // List all the draft appListings
    @AuraEnabled(cacheable = true)
    public static List<AppListingVersion__c> getAppListingVersion(){
        Id objectRecordTypeId = Schema.SObjectType.AppListingVersion__c.getRecordTypeInfosByName().get('DraftAppListing').getRecordTypeId();
        return [SELECT Id, Name, AppName__c, AppListing__c, TagLine__c, Architecture__c, Banner__c, BusinessOverview__c, Highlights__c,InstallURL__c, ListingStatus__c, PublishStatus__c, Publisher__c, ShortDescription__c FROM AppListingVersion__c where RecordTypeId =: objectRecordTypeId ];
    }

    /********************************
        //Update all the related record related to the  AppListingVersion Record that has already been published
        @method name    : updatePublishedAppRelatedRecords
        @param1         : publishedAppList
        @author      	Shankar Mallick
        @date      	    08 Novmber,2019
    ***********************************/
    @InvocableMethod
    public static void updatePublishedAppRelatedRecords(List<Id> publishedAppList){
        try{
            Logger.push('MktpAppListingVersion', 'updatePublishedAppRelatedRecords');
            // Loggin the input parameters
            Logger.debug(' input paramter 1: publishedAppList :: ' + publishedAppList);
            // Declaring the Variables
            List<AppCategory__c> appCategoryList = new List<AppCategory__c>();
            List<AppFeature__c> appFeatureList = new List<AppFeature__c>();
            List<AppMarketIndustry__c> appIndustryList = new List<AppMarketIndustry__c>();
            List<AppRequirement__c> appRequirementList = new List<AppRequirement__c>();
        

            // Fetch the Id, AppListingVersion__c from PublishedApp
            List<PublishedApp__c> pubAppList = [Select Id, AppListingVersion__c from PublishedApp__c WHERE Id IN : publishedAppList];
            
            // For each of the Related Objects attached to the AppListingVersion, Set the PublisheApp_c field to the newly created PublishedAppId
            for(PublishedApp__c pal : pubAppList){
                
                // Update the PublishedAppId in the appCategoryRec and add it to the appCategoryList
                for(AppCategory__c appCategoryRec : [Select Id, AppListingVersion__c, PublishedApp__c FROM  AppCategory__c WHERE AppListingVersion__c = : pal.AppListingVersion__c ] ){
                    appCategoryRec.PublishedApp__c = pal.Id;
                    appCategoryList.add(appCategoryRec);
                }
                // Update the PublishedAppId in the appFeatureRec and add it to the appFeatureList
                for(AppFeature__c appFeatureRec : [Select Id, AppListingVersion__c, PublishedApp__c FROM AppFeature__c WHERE AppListingVersion__c = : pal.AppListingVersion__c ]){
                    appFeatureRec.PublishedApp__c = pal.Id;
                    appFeatureList.add(appFeatureRec);
                }
                // Update the PublishedAppId in the appRequirementRec and add it to the appRequirementList
                for(AppRequirement__c appRequirementRec : [Select Id, AppListingVersion__c, PublishedApp__c FROM  AppRequirement__c WHERE AppListingVersion__c = : pal.AppListingVersion__c ] ){
                    appRequirementRec.PublishedApp__c = pal.Id;
                    appRequirementList.add(appRequirementRec);
                }
                // Update the PublishedAppId in the appIndustryRec and add it to the AppMarketIndustry__c
                for(AppMarketIndustry__c appIndustryRec : [Select Id, AppListingVersion__c, PublishedApp__c FROM  AppMarketIndustry__c WHERE AppListingVersion__c = : pal.AppListingVersion__c ] ){
                    appIndustryRec.PublishedApp__c = pal.Id;
                    appIndustryList.add(appIndustryRec);
                }
            }
            if(appCategoryList.size()>0){
                Update appCategoryList;
            }
            if(appFeatureList.size()>0){
                Update appFeatureList;
            }
            if(appRequirementList.size()>0){
                Update appRequirementList;
            }
            if(appIndustryList.size()>0){
                Update appIndustryList;
            }

        } catch(Exception ex){
             Logger.debugException(ex);
        } finally {
            Logger.pop();
        }

    }
    @AuraEnabled
    public static void throwException(String errorString){
        if (String.isBlank(errorString)) {
            throw new AuraHandledException(errorString);
        }
    }

    @AuraEnabled
    public static void cloneAppVersionCategory(Id newAppLisingVersionId, Id origAppListingVersionId){
        // Log the input variables
        Logger.debug(' input paramter 1: newAppLisingVersionId :: ' + newAppLisingVersionId);
        Logger.debug(' input paramter 1: origAppListingVersionId :: ' + origAppListingVersionId);
        // Declaring the Variables
        List<AppCategory__c> appCategoryList = new List<AppCategory__c>();
       
        for(AppCategory__c appCategoryRec : [Select Id, AppListingVersion__c, PublishedApp__c, Category__c FROM  AppCategory__c WHERE AppListingVersion__c = : origAppListingVersionId ] ){    
           AppCategory__c newAppCategoryRec =  appCategoryRec.clone(false, true, false,false);
        
            // Update the newAppLisingVersionId in the newAppCategoryRec and add it to the appCategoryList
            newAppCategoryRec.PublishedApp__c = null;
            newAppCategoryRec.AppListingVersion__c = newAppLisingVersionId;
            appCategoryList.add(newAppCategoryRec);
            Logger.debug(' appCategoryList :: ' + appCategoryList);
        } 

        if(appCategoryList.size()>0){
            Insert appCategoryList;
        }
    }

    @AuraEnabled
    public static void cloneAppVersionIndustry(Id newAppLisingVersionId, Id origAppListingVersionId){
        // Log the input variables
        Logger.debug(' input paramter 1: newAppLisingVersionId :: ' + newAppLisingVersionId);
        Logger.debug(' input paramter 1: origAppListingVersionId :: ' + origAppListingVersionId);

        // Declare the variables
        List<AppMarketIndustry__c> appIndustryList = new List<AppMarketIndustry__c>();

        for(AppMarketIndustry__c appIndustryRec : [Select Id, AppListingVersion__c, MarketIndustry__c, OwnerId, PublishedApp__c FROM  AppMarketIndustry__c WHERE AppListingVersion__c = : origAppListingVersionId ] ){
            AppMarketIndustry__c newIndustryRec = appIndustryRec.clone(false, true, false,false);
            newIndustryRec.PublishedApp__c = null;
            newIndustryRec.AppListingVersion__c = newAppLisingVersionId;
            appIndustryList.add(newIndustryRec);
            Logger.debug(' appIndustryList :: ' + appIndustryList);

        }

        if(appIndustryList.size()>0){
            Insert appIndustryList;
        }
    }

    @AuraEnabled
    public static void cloneAppVersionFeature(Id newAppLisingVersionId, Id origAppListingVersionId){
        // Log the input variables
        Logger.debug(' input paramter 1: newAppLisingVersionId :: ' + newAppLisingVersionId);
        Logger.debug(' input paramter 1: origAppListingVersionId :: ' + origAppListingVersionId);

        // Declare the variables
        List<AppFeature__c> appFeatureList = new List<AppFeature__c>();

        for(AppFeature__c appFeatureRec : [Select Id, AppListingVersion__c, Name, FeatureType__c, Free__c, FreeTrialAvailable__c, Paid__c, SupportedLanguage__c, Supported_OS__c, OwnerId, PublishedApp__c FROM  AppFeature__c WHERE AppListingVersion__c = : origAppListingVersionId ] ){
            AppFeature__c newFeatureRec = appFeatureRec.clone(false, true, false,false);
            newFeatureRec.PublishedApp__c = null;
            newFeatureRec.AppListingVersion__c = newAppLisingVersionId;
            appFeatureList.add(newFeatureRec);
            Logger.debug(' appFeatureList :: ' + appFeatureList);
        }

        if(appFeatureList.size()>0){
            Insert appFeatureList;
        }
    }

    @AuraEnabled
    public static void cloneAppVersionRequirement(Id newAppLisingVersionId, Id origAppListingVersionId){
         if (String.isBlank(newAppLisingVersionId) || String.isBlank(origAppListingVersionId) ) {
            throwException('Either the Record Id is blank or New Version Name is Blank');
        } else {
            // Log the input variables
            Logger.debug(' input paramter 1: newAppLisingVersionId :: ' + newAppLisingVersionId);
            Logger.debug(' input paramter 1: origAppListingVersionId :: ' + origAppListingVersionId);
            
            // Declaring the Variables
            List<AppRequirement__c> appRequirementList = new List<AppRequirement__c>();
            
            // Loop through the list of existing Requirement records associated to the original record
            // clone them and update the new AppListingVersiondId
            // Remove the refence to PublishedApp__c if any
            for(AppRequirement__c appRequirementRec : [Select Id, Name, AppListingVersion__c, Requirement__c, OwnerId, PublishedApp__c FROM  AppRequirement__c WHERE AppListingVersion__c = : origAppListingVersionId ] ){
                AppRequirement__c newRequirementRec = appRequirementRec.clone(false, true, false,false);
                newRequirementRec.PublishedApp__c = null;
                newRequirementRec.AppListingVersion__c = newAppLisingVersionId;
                appRequirementList.add(newRequirementRec);
                logger.debug('appRequirementList :: ' + appRequirementList);
            }

            if(appRequirementList.size()>0){
                Insert appRequirementList;
            }
        }    
    }
}