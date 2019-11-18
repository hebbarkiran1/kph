/*********************************************************************
    @name           MktpListOfParentCategories
    @author      	Kiran Prabhakara
    @date      	    11 Novmber,2019
    @description:   Gets list of parent categories and passes each category to mktpCategoryItem component
                   
************************************************************************/
import { LightningElement, track, wire } from 'lwc';
import getListOfParentCategories from'@salesforce/apex/MktpCategoriesController.getListOfParentCategories';
export default class MktpListOfParentCategories extends LightningElement {
  
    // Declare the properties
    @track parentCategories;
    @track error;

    @wire(getListOfParentCategories) parentCategories;
    

}