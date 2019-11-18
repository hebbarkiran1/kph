@isTest 
private class MktpCategoriesControllerTest {
    static testMethod void validateMktpCategories() {
      List<Category__c> categoryList = new List<Category__c>();
      Category__c category1 = new Category__c(name='Analytics and Automation Software',CategoryType__c='Parent');
      categoryList.add(category1);
      Category__c category2 = new Category__c(name='Conferencing',CategoryType__c='Parent');
      categoryList.add(category2);
      Category__c category3 = new Category__c(name='Contact Center',CategoryType__c='Parent');
      categoryList.add(category3);
      Category__c category4 = new Category__c(name='Optical Networking',CategoryType__c='Parent');
      categoryList.add(category4);
      Category__c category5 = new Category__c(name='Security',CategoryType__c='Parent');
      categoryList.add(category5);
      insert categoryList;
      MktpCategoriesController.getListOfParentCategories();

      
    }
}