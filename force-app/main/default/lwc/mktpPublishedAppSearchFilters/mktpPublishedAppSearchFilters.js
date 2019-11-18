import { LightningElement,wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getPublishedAppFilters from '@salesforce/apex/mktpPublishedAppSearchFiltersController.getPublishedAppFilters';
import { fireEvent } from 'c/pubsub';

class Filters{
    name='';
    values =[];
}

export default class mktpPublishedAppSearchFilters extends LightningElement {
    @track filterMap=[];
    filtersToApply = new Array(new Filters());
    @track errorMsg;


    @wire(CurrentPageReference) pageRef;

    @wire(getPublishedAppFilters)
    loadFilters(result)
    {
        if(result.data)
        {
            for(let i = 0; i < result.data.length; i++)
            {
                this.filterMap.push({key:result.data[i].name,value:result.data[i].values});
            }
            this.errorMsg = undefined;
        }
        if(result.error)
        {
            this.errorMsg = result.error.body.message;
            this.filterMap=undefined;
        }        
    }

    

    handleSelectionfromButton()
    {
        // const selectEvent = new CustomEvent('filterchange', {
        //     detail: this.filtersToApply
        // });
        // this.dispatchEvent(selectEvent);  

        fireEvent(this.pageRef, 'filterchange', this.filtersToApply);
    }

    handleResetSelection()
    {
        this.filtersToApply = [];

           let checkboxes = Array.from(
            this.template.querySelectorAll('lightning-input')
        )
            for(let i =0; i<checkboxes.length ; i++)
            {
                checkboxes[i].checked =false;
            }

        // const selectEvent = new CustomEvent('filterchange', {
        //     detail: this.filtersToApply
        // });
        // this.dispatchEvent(selectEvent);   

        fireEvent(this.pageRef, 'filterchange', this.filtersToApply);
    }

    handleSelection(event) {
         // Query the DOM
        // const checked = Array.from(
        //     this.template.querySelectorAll('lightning-input')
        // )
        //     // Filter down to checked items
        //     .filter(element => element.checked)
        //     // Map checked items to their labels
        //     .map(element => element.label);
        // this.selectedValues = checked.join(', ');
        var filterAdded = false;

       if(this.filtersToApply.length === 1 && this.filtersToApply[0].name ==='')
            this.filtersToApply.shift();    

        if(this.filtersToApply !== undefined)
        {
            for(let i=0; i < this.filtersToApply.length; i++)
            {
                if(this.filtersToApply[i].name === event.target.name)
                {
                    if(event.target.type === "checkbox")
                    {
                        if(event.target.checked)
                        {
                            this.filtersToApply[i].values.push(event.target.value);
                        }
                        else
                        {
                            this.filtersToApply[i].values =  this.filtersToApply[i].values.filter(function(value){
                                return value !== event.target.value;
                            });
                        }
                        
                    }
                    if(event.target.type === "horizontal" || event.target.type === "select-one")
                    {
                        if(event.target.value !== 'All'){
                            this.filtersToApply[i].values= [event.target.value];
                        }
                            else
                            {
                                // Remove all the value if ALL is selected, only for Dropdown type
                                this.filtersToApply[i].values =  [];
                            }
                    }
                

                    //remove the filter name from the list if no values selected.
                    if(this.filtersToApply[i].values.length < 1)
                    {
                        this.filtersToApply = this.filtersToApply.filter(function(value){
                            return value.name !== event.target.name;  
                        });
                    }
                    filterAdded = true;
                }
            }
        }

        if(!filterAdded)
        {
            let fill= new Filters();
            fill.name = event.target.name;
            fill.values = [event.target.value];
            this.filtersToApply.push (fill)  
        }

    }
}