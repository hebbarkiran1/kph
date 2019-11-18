import { LightningElement, api, wire } from 'lwc';
import {getRecord, getFieldValue} from 'lightning/uiRecordApi';
import PUBLISHEDAPP from '@salesforce/schema/PublishedApp__c';
import NAME_FIELD from '@salesforce/schema/PublishedApp__c.Name'
//import APP_LISTING_VERSION from '@salesforce/schema/PublishedApp__c.AppListingVersion__c'
export default class LwcDemoSession3UIRecordAPI extends LightningElement {
    @api recordId;

    publishedAppObject = PUBLISHEDAPP;
    

    @wire (getRecord,{ recordId: 'a043i00000698NbAAI', fields : [NAME_FIELD]})
    record;

    // get the Published App Name
    get nameValue(){
        console.log('this.record.data :' + this.record.data);
        return this.record.data ? getFieldValue(this.record.data, NAME_FIELD) : '';
    }

}