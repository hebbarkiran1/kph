public without sharing class MktpPublishedAppController {
    /*******************************************************************************************
    @name           MktpPublishedAppController
    @author      	Ashwani
    @date      	    07 Novmber,2019
    @description:   This controller is to fetch, update PublishedAppDate
    Revision(s):	
                  
    **********************************************************************************************/
    public MktpPublishedAppController() {

    }

    @AuraEnabled(Cacheable=true)
    public static AppFeature__c[] searchApps(String searchTerm, string appliedFilters) {
        // Return all Apps when no search term
        searchTerm = searchTerm.trim();

        if(searchTerm != '')
        {
            searchTerm = 'WHERE AppListingName__c LIKE \'%'+ searchTerm +'%\' ';
        }      
        List<Filters> filtersToApply =new List<Filters>();
        if(!appliedFilters.equals(''))
            filtersToApply = (List<Filters>)JSON.deserialize(appliedFilters, List<Filters>.class);

        System.debug(filtersToApply);
        List<String> filterTerms = new List<String>();

        if(filtersToApply.size() > 0)
        {
             // Prepare query paramters
            for(Filters filter : filtersToApply)
            {
                System.debug('Filter Name: '+filter.name);

                if(filter.name == 'Price')
                {
                    if(searchTerm != '')
                    {
                        searchTerm = searchTerm + 'AND (';
                    }
                    else {
                        searchTerm = searchTerm + 'WHERE (';
                    }
                    
                    for (string s : filter.values)
                    {
                        if(s == 'Free Trial Available')
                        {
                            filterTerms.add('FreeTrialAvailable__c = true');
                        }
                        if(s == 'Free')
                        {
                            filterTerms.add('Free__c = true');
                        }
                        if(s == 'Paid')
                        {
                            filterTerms.add('Paid__c = true');
                        }
                    }
                    searchTerm = searchTerm + String.join(filterTerms,' OR ') + ') ';
                }

                filterTerms.clear();

                if(filter.name == 'Supported Language')
                {
                    if(searchTerm != '')
                    {
                        searchTerm = searchTerm + 'AND ';
                    }
                    else {
                        searchTerm = searchTerm + 'WHERE ';
                    }
                    searchTerm = searchTerm + 'SupportedLanguage__c IN(';
                    for (string s : filter.values)
                    {
                        filterTerms.add('\''+s+'\'');
                    }
                    searchTerm = searchTerm + String.join(filterTerms,',') + ') ';
                }
                
                filterTerms.clear();
                if(filter.name == 'Supported OS')
                {
                    if(searchTerm != '')
                    {
                        searchTerm = searchTerm + 'AND ';
                    }
                    else {
                        searchTerm = searchTerm + 'WHERE ';
                    }
                        searchTerm = searchTerm + 'Supported_OS__c IN (';    
                    
                    for (string s : filter.values)
                    {
                         filterTerms.add('\''+s+'\'');
                    }

                    searchTerm = searchTerm + String.join(filterTerms,',') + ') ';

                }
            }
        }
        String query = 'SELECT AppListingVersion__r.Id, AppListingName__c, FreeTrialAvailable__c, Supported_OS__c, SupportedLanguage__c, Free__c, Paid__c FROM AppFeature__c '+ searchTerm + ' ORDER BY Name LIMIT 12';
        System.debug('Query debug:' +query);

        // Execute search query
        return Database.query(query);
    }

    @AuraEnabled(Cacheable=true)
    public static List<Filters> getFilters()
    {
       List<Filters> appFilters = new List<Filters>();
        
        // sObject types to describe
        String[] types = new String[]{'AppFeature__c'};
        // Make the describe call
        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(types);

        // For each returned result, get some info
        for(Schema.DescribeSobjectResult res : results) {
            
            System.debug('MAP of fields: ' + res.fields.getMap());
        
            for(Schema.SObjectField field : res.fields.getMap().Values() )
            { 
                schema.describefieldresult dfield = field.getDescribe();
					if(dfield.getType().name()=='PICKLIST' && dfield.getName() != 'FeatureType__c')
                    {
                        Filters filtertoadd = new Filters();
                        filtertoadd.name = dfield.getLabel();
                        filtertoadd.values = new List<String>();

                        for( Schema.PicklistEntry entry : dfield.getpicklistvalues())
                        {
                              filtertoadd.values.add(entry.getValue());  
                        }
                        
                        appFilters.add(filtertoadd);
                    }
                    
                    if(dfield.getType().name()=='BOOLEAN' && dfield.getName() != 'IsDeleted')
                    {
                        Boolean filterAdded = false;
                        if(appFilters.size()>0)
                        {
                            for (Filters existing : appFilters)
                            {
                                if(existing.name == 'Price')
                                {
                                    existing.values.add(dfield.getLabel());
                                    filterAdded = true;
                                }
                            }
                        }

                        if(!filterAdded) {
                            Filters filtertoadd = new Filters();
                            filtertoadd.name = 'Price';
                            filtertoadd.values = new List<String>();
                            filtertoadd.values.add(dfield.getLabel());     
                            appFilters.add(filtertoadd);    
                        }
                    }
            }
         System.debug(appFilters);
        }
        return appFilters;
    }

    /********************************
        //Get the List of WrapperClass of Published Apps
        @method name    : getPublishedAppWrapper
        @param1         : Set<Id> - Set of Published App Id
        @outputparam    : List<publishedAppWrapper>
        @author      	: Shankar Mallick
        @date      	    : 12 November,2019
    ***********************************/
    public static List<publishedAppWrapper> getPublishedAppWrapper(Set<Id> publishedAppSet){
        
        // Declare all the variables
        List<publishedAppWrapper> publishedWrapperList = new List<publishedAppWrapper>(); // List for storing the final output
        Map<Id, List<AppFeature__c>> appFeatureMap = new Map<Id, List<AppFeature__c>>(); // Map for holding the FeatureList based on the Published App Id
        Map<Id, List<AppCategory__c>> appCategoryMap = new Map<Id, List<AppCategory__c>>(); // Map for holding all the Categories based on the Published App Id
        // Get the List of PublishedApps and create a map publishedAppMap based out of it
        Map<Id, PublishedApp__c> publishedAppMap = new  Map<Id, PublishedApp__c>([SELECT Id, Name, AboutPublisher__c,  Architecture__c, BusinessOverview__c, Highlights__c, NumberOfInstalls__c, NumberOfReviews__c, CalculatedRating__c, Logo__c, LongDescription__c, PublishDate__c, PublishStatus__c, Publisher__c, PublisherType__c,  ShortDescription__c, TagLine__c, TechnicalOverview__c FROM PublishedApp__c WHERE Id IN : publishedAppSet]);

        // Get all the features  related to all the above Published Apps in a List
        List<AppFeature__c> appFeatureList = [ Select Id, Name, PublishedApp__c, FeatureType__c, Free__c, Paid__c, FreeTrialAvailable__c, SupportedLanguage__c, Supported_OS__c FROM AppFeature__c WHERE PublishedApp__c IN : publishedAppMap.keySet()];

        // Loop through the list appFeatureList and add it to the appFeatureMap
        for(AppFeature__c appFeatureRecord : appFeatureList){
            if(appFeatureMap.get(appFeatureRecord.PublishedApp__c)==null){
                List<AppFeature__c> featureList = new List<AppFeature__c>();
                featureList.add(appFeatureRecord);
                appFeatureMap.put(appFeatureRecord.PublishedApp__c,featureList);
            } else {
                appFeatureMap.get(appFeatureRecord.PublishedApp__c).add(appFeatureRecord);
            }
        }

        // Get all the Categories related to all the above PublishedApp in a List
        List<AppCategory__c> appCategoryList = [Select Id, Category__c, PublishedApp__c, CategoryType__c, ParentCategory__c, ParentCategoryId__c, GrandparentCategory__c, GrandparentCategoryId__c FROM AppCategory__c WHERE PublishedApp__c IN : publishedAppMap.keySet() ];
        
        // Loop throught the List appCategoryList and add it to the appCategoryMap
        for(AppCategory__c appCategoryRecord : appCategoryList){
            if(appCategoryMap.get(appCategoryRecord.PublishedApp__c) == null){
                List<AppCategory__c> categoryList = new List<AppCategory__c>();
                categoryList.add(appCategoryRecord);
                appCategoryMap.put(appCategoryRecord.PublishedApp__c, categoryList);
            } else {
                appCategoryMap.get(appCategoryRecord.PublishedApp__c).add(appCategoryRecord);
            }
        }

        // Loop through all the PublishedApps in the publishedAppMap and create the publishedAppWrapper Record
        for(PublishedApp__c publishedAppRecord : publishedAppMap.values()){
            // create a new wrapper record
            publishedAppWrapper wrapperRecord = new publishedAppWrapper();
            // Add the publishedApp values from the Map to the app property
            wrapperRecord.app = publishedAppRecord;
            wrapperRecord.appId = publishedAppRecord.Id;
            wrapperRecord.cardTitle = publishedAppRecord.Name;
            // Add the Features from the appFeatureMap to the Features List of Wrapper record
            if(appFeatureMap.get(publishedAppRecord.Id)!= null){
                wrapperRecord.appFeatureList = appFeatureMap.get(publishedAppRecord.Id);
                for(AppFeature__c appFeatureRecord : appFeatureMap.get(publishedAppRecord.Id)){
                        if(appFeatureRecord.FeatureType__c == 'Free' && appFeatureRecord.Free__c == true){
                             wrapperRecord.freeApp = true;
                        }  
                } 
            }

            // Add the Categories from the AppCategoryMap to the CategoryList of Wrapper record
            if(appCategoryMap.get(publishedAppRecord.Id) != null){
                wrapperRecord.appCategoryList = appCategoryMap.get(publishedAppRecord.Id);
            }

            // Now add the current record to the WrapperList 
            publishedWrapperList.add(wrapperRecord);
        }

        return publishedWrapperList;
    }
}