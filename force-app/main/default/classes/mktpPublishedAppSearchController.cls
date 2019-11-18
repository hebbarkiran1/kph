public without sharing class mktpPublishedAppSearchController {
    public mktpPublishedAppSearchController() {

    }
     /********************************
        //Search Published apps based on the searchTerm and appliedFilters, if any
        @method name    : applyFilsearchAppsters
        @param1         : 
        @returns        : List<PublishedApp__c>
        @author      	Ashwani Bothra
        @date      	    08 Novmber,2019
    ***********************************/
    @AuraEnabled(Cacheable=true)
    public static List<MktpPublishedAppWrapper> searchApps(String searchTerm, string appliedFilters) {
        // Return all Apps when no search term
        searchTerm = searchTerm.trim();

        if(searchTerm != '')
        {
            searchTerm = 'AND (Name LIKE \'%'+ searchTerm +'%\' OR AppListingVersion__r.TagLine__c LIKE \'%'+ searchTerm +'%\' OR ShortDescription__c LIKE \'%'+ searchTerm +'%\')';
        }      
        List<Filters> filtersToApply =new List<Filters>();
        if(!appliedFilters.equals(''))
            filtersToApply = (List<Filters>)JSON.deserialize(appliedFilters, List<Filters>.class);

        System.debug(filtersToApply);
        String query = Database.getQueryLocator('SELECT Id, Name  FROM PublishedApp__c WHERE  PublishStatus__c=\'Active\' '+ searchTerm + ' ORDER BY Name LIMIT 12').getQuery();
        System.debug('Query debug:' +query);



        Map<Id,PublishedApp__c> mapPublishedApps = new Map<Id, PublishedApp__c>((List<PublishedApp__c>)Database.query(query));
        List<PublishedApp__c> filteredPublishedApps = new List<PublishedApp__c>();

        if(filtersToApply.size() >0)
            return applyFilters(mapPublishedApps, filtersToApply);
        else
            return getPublishedAppWrapper(mapPublishedApps.keySet());

    }

    /********************************
        //Apply filters selected from the search results page
        @method name    : applyFilters
        @param1         : 
        @returns        : List<PublishedApp__c>
        @author      	Ashwani Bothra
        @date      	    08 Novmber,2019
    ***********************************/
    private static List<MktpPublishedAppWrapper> applyFilters(Map<Id,PublishedApp__c> mapPublishedApps, List<Filters> filtersToApply)
    {
        //string searchTerm='(\'' + String.join(new List<Id>(mapPublishedApps.keySet()),',') + ') ';
        string searchTerm='';
        List<String> filterTerms = new List<String>();
        Set<Id> appKeySet = mapPublishedApps.keySet();

        if(filtersToApply.size() > 0)
        {
             // Prepare query paramters
            for(Filters filter : filtersToApply)
            {
                System.debug('Filter Name: '+filter.name);

                if(filter.name == 'Price')
                {                       
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
                    searchTerm = searchTerm + 'AND ('+ String.join(filterTerms,' OR ') + ') ';
                }

                filterTerms.clear();

                if(filter.name == 'Supported Language' && filter.values.size() > 0)
                {
                    for (string s : filter.values)
                    {
                        filterTerms.add('\''+s+'\'');
                    }
                    searchTerm = searchTerm+ 'AND SupportedLanguage__c IN(' + String.join(filterTerms,',') + ') ';
                }
                
                filterTerms.clear();
                if(filter.name == 'Supported OS' && filter.values.size() > 0)
                {   
                    for (string s : filter.values)
                    {
                         filterTerms.add('\''+s+'\'');
                    }

                    searchTerm = searchTerm +'AND Supported_OS__c IN (' + String.join(filterTerms,',') + ') ';

                }
            }

            // filter the published apps based on filters selected on Search page
            String filterQuery = 'Select PublishedApp__c, FeatureType__c, Free__c, Paid__c, FreeTrialAvailable__c, SupportedLanguage__c, Supported_OS__c FROM AppFeature__c WHERE PublishedApp__c IN : appKeySet '
                                        +searchTerm + ' Limit 12';
            
            // get the list of published apps filtered by the filtersToApply
            for(Appfeature__c app: Database.query(filterQuery)){
                if(mapPublishedApps.get(app.PublishedApp__c) == null){
                    appKeySet.remove(app.PublishedApp__c);
                }
            }
        }
 
        return getPublishedAppWrapper(appKeySet);
    }

    /********************************
        //Get the List of WrapperClass of Published Apps
        @method name    : getPublishedAppWrapper
        @param1         : Set<Id> - Set of Published App Id
        @outputparam    : List<publishedAppWrapper>
        @author      	: Shankar Mallick
        @date      	    : 12 November,2019
    ***********************************/
    public static List<MktpPublishedAppWrapper> getPublishedAppWrapper(Set<Id> publishedAppSet){
        
        // Declare all the variables
        List<MktpPublishedAppWrapper> publishedWrapperList = new List<MktpPublishedAppWrapper>(); // List for storing the final output
        Map<Id, List<AppFeature__c>> appFeatureMap = new Map<Id, List<AppFeature__c>>(); // Map for holding the FeatureList based on the Published App Id
        Map<Id, List<AppCategory__c>> appCategoryMap = new Map<Id, List<AppCategory__c>>(); // Map for holding all the Categories based on the Published App Id

        // Get the List of PublishedApps and create a map publishedAppMap based out of it
        Map<Id, PublishedApp__c> publishedAppMap = new  Map<Id, PublishedApp__c>([SELECT Id, Name, AboutPublisher__c,  Architecture__c, BusinessOverview__c, Highlights__c, 
                                                                                        NumberOfInstalls__c,InstallURL__c, NumberOfReviews__c, CalculatedRating__c, Logo__c, LongDescription__c, 
                                                                                        PublishDate__c, PublishStatus__c, Publisher__c, PublisherType__c,  ShortDescription__c, 
                                                                                        TagLine__c, TechnicalOverview__c 
                                                                                    FROM PublishedApp__c 
                                                                                    WHERE Id IN : publishedAppSet]);

        // Get all the features  related to all the above Published Apps in a List
        List<AppFeature__c> appFeatureList = [Select Id, Name, PublishedApp__c, FeatureType__c, Free__c, Paid__c, 
                                                        FreeTrialAvailable__c, SupportedLanguage__c, Supported_OS__c 
                                                FROM AppFeature__c 
                                                WHERE PublishedApp__c IN : publishedAppMap.keySet()];

        // Loop through the list appFeatureList and add it to the appFeatureMap by ID
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
        List<AppCategory__c> appCategoryList = [Select Id, Category__c,Name, PublishedApp__c, CategoryType__c, ParentCategory__c, 
                                                        ParentCategoryId__c, GrandparentCategory__c, GrandparentCategoryId__c 
                                                    FROM AppCategory__c 
                                                    WHERE PublishedApp__c IN : publishedAppMap.keySet() ];
        
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

        // Loop through all the PublishedApps in the publishedAppMap and create the MktpPublishedAppWrapper Record
        for(PublishedApp__c publishedAppRecord : publishedAppMap.values()){

            MktpPublishedAppWrapper wrapperRecord = new MktpPublishedAppWrapper();
            wrapperRecord.appTitle = publishedAppRecord.Name;
            wrapperRecord.appId = publishedAppRecord.Id;
            wrapperRecord.logoURL = publishedAppRecord.Logo__c;
            wrapperRecord.tagLine = publishedAppRecord.TagLine__c;
            wrapperRecord.publishedBy = publishedAppRecord.Publisher__c;
            wrapperRecord.appStatus = publishedAppRecord.PublishStatus__c;
            wrapperRecord.publishedDate = publishedAppRecord.PublishDate__c.year()+'/'+ publishedAppRecord.PublishDate__c.month()+'/'+ publishedAppRecord.PublishDate__c.day(); 
            wrapperRecord.installURL = publishedAppRecord.InstallURL__c;
            wrapperRecord.rating = String.valueOf(publishedAppRecord.CalculatedRating__c);
            
            appFeatureList = appFeatureMap.get(publishedAppRecord.Id);
            if(appFeatureList != null && appFeatureList.size() >0)
            {
                for(AppFeature__c feature : appFeatureList){
                    if(feature.Free__c == true)
                    {
                        wrapperRecord.pricing.add('Free');
                    }
                    if(feature.Paid__c == true)
                    {
                        wrapperRecord.pricing.add('Paid');
                    }
                    if(feature.FreeTrialAvailable__c == true)
                    {
                        wrapperRecord.pricing.add('Free Trial Available');
                    }

                    if(feature.SupportedLanguage__c != null)
                    {
                        wrapperRecord.supportedLang.add(feature.SupportedLanguage__c);
                    }
                    if(feature.Supported_OS__c != null)
                    {
                        wrapperRecord.supportedOS.add(feature.Supported_OS__c);
                    }
                }
            }

            appCategoryList = appCategoryMap.get(publishedAppRecord.Id);
            if(appCategoryList != null && appFeatureList.size() > 0)
            {
                for(AppCategory__c category : appCategoryMap.get(publishedAppRecord.Id))
                {
                    wrapperRecord.categories.add(category.Name);
                }
            }
            // create a new wrapper record
           /* MktpPublishedAppWrapper wrapperRecord = new MktpPublishedAppWrapper();
            // Add the publishedApp values from the Map to the app property
            wrapperRecord.app = publishedAppRecord;
            wrapperRecord.appId = publishedAppRecord.Id;
            wrapperRecord.cardTitle = publishedAppRecord.Name;
            wrapperRecord.isFreeOrPaidApp = false;
            // Add the Features from the appFeatureMap to the Features List of Wrapper record
            if(appFeatureMap.get(publishedAppRecord.Id)!= null){
                wrapperRecord.appFeatureList = appFeatureMap.get(publishedAppRecord.Id);
                for(AppFeature__c feature :  wrapperRecord.appFeatureList)
                {
                    if((feature.FeatureType__c == 'Free' && feature.Free__c == true) || (feature.FeatureType__c == 'Paid' && feature.Paid__c == true))
                    {
                        wrapperRecord.isFreeOrPaidApp = true;
                    }
                    
                }
                
            }

            // Add the Categories from the AppCategoryMap to the CategoryList of Wrapper record
            if(appCategoryMap.get(publishedAppRecord.Id) != null){
                wrapperRecord.appCategoryList = appCategoryMap.get(publishedAppRecord.Id);
            } */

            // Now add the current record to the WrapperList 
            publishedWrapperList.add(wrapperRecord);
        }

        return publishedWrapperList;
    }
}