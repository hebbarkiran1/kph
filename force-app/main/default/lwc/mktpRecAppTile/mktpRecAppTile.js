import { LightningElement,api } from 'lwc';
import myResource from '@salesforce/resourceUrl/ciscoplaceholder';

export default class mktpRecAppTile extends LightningElement {
    @api temp;
    appLogo= myResource;
}