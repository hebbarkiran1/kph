import { LightningElement, wire,track } from 'lwc';
import getPublishedApp from '@salesforce/apex/MKTP_appListingVersion.MKTP_getPublishedApp';
export default class LwcDemoSession2WireFunction extends LightningElement {
    @track publishedApp;
    @track error;

    @wire(getPublishedApp)
    wiredPublishedApp({error,data}){
        if(data){
            this.publishedApp = data;
            this.error = undefined;
        } else if (error) {
            this.publishedApp = undefined ;
            this.error = error;
        }
    }


}