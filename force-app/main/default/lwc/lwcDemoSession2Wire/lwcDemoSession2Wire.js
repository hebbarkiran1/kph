import { LightningElement, wire } from 'lwc';
import getPublishedApp from '@salesforce/apex/MKTP_appListingVersion.MKTP_getPublishedApp'

export default class LwcDemoSession2Wire extends LightningElement {
    @wire(getPublishedApp) publishedApps;
}