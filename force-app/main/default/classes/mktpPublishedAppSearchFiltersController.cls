public with sharing class mktpPublishedAppSearchFiltersController {
    public mktpPublishedAppSearchFiltersController() {

    }

     /********************************
        //Get all the availalbe filter name with values from the AppFeatures__C object.
        @method name    : getPublishedAppFilters
        @param1         : 
        @returns        : List<Filters>
        @author      	Ashwani Bothra
        @date      	    08 Novmber,2019
    ***********************************/
    @AuraEnabled(Cacheable=true)
    public static List<Filters> getPublishedAppFilters()
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