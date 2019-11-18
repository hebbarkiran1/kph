import { LightningElement, track, wire, api } from 'lwc';
import getMarketingContent from '@salesforce/apex/MktpMarketingContent.getMarketingContent'

const COLS = [
    { label: 'File Name', fieldName: 'this.content.Title', editable: true },
    { label: 'Path', fieldName: 'this.content.PathOnClient', editable: true },
    { label: 'DocumentType', fieldName: 'this.content.DocumentType__c' },
    { label: 'Content Type', fieldName: 'this.content.ContentType__c'},
    { label: 'Owner', fieldName: 'this.content.OwnerId'}
];
export default class MktpMarketingContent extends LightningElement {

    // Declare the properties
    @api recordId;
    @track error;
    //@track content;
    @track columns = COLS;
    @track draftValues = [];

    // wire the getMarketingContent method
    @wire(getMarketingContent, {appListingVersionId: '$recordId'}) content;

    /*
    wiredContent({error,data}){
        if(data){
            console.log('returned data ::'  + JSON.stringify(data, null, '\t'));
            //this.content = data.conVerList;
            //console.log('content data ::'  + JSON.stringify(this.content, null, '\t'));
            this.error = undefined;
        } else if (error) {
            this.content = undefined ;
            this.error = error;
        }
    }
    */
}