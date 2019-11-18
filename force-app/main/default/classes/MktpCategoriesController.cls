public without sharing class MktpCategoriesController {
    /*******************************************************************************************
    @name           MktpCategoriesController
    @author      	Kiran Prabhakara
    @date      	    11 Novmber,2019
    @description:   This controller is used to fetch the List of parent Categories
    Revision(s):	
                  
    **********************************************************************************************/
    
    @AuraEnabled(cacheable = true)
    public static List<Category__c> getListOfParentCategories() {
        return [Select Id, Name, CategoryType__c from Category__c WHERE CategoryType__c = 'Parent' order by Name];
    }
}