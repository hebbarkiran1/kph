public without sharing class PublishedAppController {
    public PublishedAppController() {

    }

    @AuraEnabled(Cacheable=true)
    public static AppFeature__c[] searchApps(String searchTerm, List<Filters> filtersToApply) {
        // Return all Apps when no search term
        searchTerm = searchTerm.trim();

        if(searchTerm != '')
        {
            searchTerm = 'WHERE NAME LIKE \'%'+ searchTerm +'%\' ';
        }      

        // Prepare query paramters

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
        String query = 'SELECT AppListingVersion__r.Id, AppListingName__c, FreeTrialAvailable__c, Supported_OS__c, SupportedLanguage__c, Free__c, Paid__c FROM AppFeature__c '+ searchTerm + ' ORDER BY Name LIMIT 50';
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
}