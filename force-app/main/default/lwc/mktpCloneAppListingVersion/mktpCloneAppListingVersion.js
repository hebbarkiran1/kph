import { LightningElement, track, api } from 'lwc';
import cloneCurrentAppListing from '@salesforce/apex/MktpAppListingVersion.cloneNewAppListingVersion';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MktpCloneAppListingVersion extends LightningElement {
    /*********************************************************************
    @name           MktpCloneAppListingVersion
    @author      	Shankar Mallick
    @date      	    06 Novmber,2019
    @description:   This lwc is used to clone existing AppListingVersion ta
 	
                    // This LWC provides a input text box to the User to input the new version Name
                    // On Submit the component calls the Apex Method using @wire to create a new cloned recordn and cloned child record that are related to the cloned record
    ************************************************************************/


    // declaring the variables
    @api recdid;
    @track gatherNewVersion = true;
    @track newVersion;
    @track error;

    // 
    handleSubmit(){
        console.log('logging the input parmaters');
        console.log('record id ::' + this.recdid);
        console.log('new version name ::' + this.newVersion);
        cloneCurrentAppListing({appListingVersionId : this.recdid, newVersionName : this.newVersion} )
            .then(result => {
                this.gatherNewVersion = false;
                this.appListingVersion = result;
                console.log('result ::'  + JSON.stringify(result, null, '\t'));
                this.error = undefined;
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'You have successfully cloned this record',
                        variant: 'success'
                    })
                );
            })
            .catch(error=>{
                this.gatherNewVersion = false;
                this.error = error;
                console.log('error ::'  + JSON.stringify(this.error, null, '\t'));
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error Encountered',
                        message: error.message,
                        variant: 'error'
                    })
                );
            })
    }

    handleChange(event) {
        this.newVersion = event.target.value;
        console.log('new versions : ' + this.newVersion);
    }

    handleCancel(){

    }

}