import { LightningElement, api } from 'lwc';

export default class MktpCategoryItem extends LightningElement {
    /*********************************************************************
    @name           MktpCategoryItem
    @author      	Kiran Prabhakara
    @date      	    11 Novmber,2019
    @description:   Generates a List Item with Category Name and link which dispatches the select event 
                   
    ************************************************************************/
    // Declare the property
    @api category;


    handleClick(event) {
            event.preventDefault();
        const selectEvent = new CustomEvent('select', {
            detail: this.category.Id
        });
        this.dispatchEvent(selectEvent);
    }
}