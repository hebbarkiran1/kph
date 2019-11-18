import { LightningElement, api, track } from 'lwc';
import { reduceErrors } from 'c/ldsUtils';

export default class MktpErrorPanel extends LightningElement {
    /*********************************************************************
    @name           MktpErrorPanel
    @author      	Shankar Mallick
    @date      	    06 Novmber,2019
    @description:   Generic Component to display the error messages
                    Provided by SFDC in the sample LWC Recipies project
 	
                    // This LWC provides a displays the error message 
                    // only if the error property is set by the parent
                    // error message can be a single error message or an array of messages
    ************************************************************************/

    /** Generic / user-friendly message */
    @api friendlyMessage = 'Error retrieving data';

    @track viewDetails = false;

    /** Single or array of LDS errors */
    @api errors;

    get errorMessages() {
        return reduceErrors(this.errors);
    }

    handleCheckboxChange(event) {
        this.viewDetails = event.target.checked;
    }
}