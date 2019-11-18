import { LightningElement, track } from 'lwc';
import getAppListingVersion from '@salesforce/apex/MKTP_appListingVersion.MKTP_getAppListingVersion';

export default class LwcDemoSession2WireImperative extends LightningElement {

    @track appListingVersion;
    @track error;

    handleLoad(){
        getAppListingVersion()
            .then(result => {
                this.appListingVersion = result;
                this.error = undefined;
            })
            .catch(error=>{
                this.appListingVersion = undefined;
                this.error = error;
            })
    }
}