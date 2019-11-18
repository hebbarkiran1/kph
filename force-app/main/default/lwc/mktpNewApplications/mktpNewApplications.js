import { LightningElement, wire } from 'lwc';
import mktp_fetchNewApps from '@salesforce/apex/mktp_newApplicationsController.mktp_fetchNewApps'
import myResource from '@salesforce/resourceUrl/Tile';

export default class newApplicationsCard extends LightningElement {
    appLogo = myResource;
    @wire(mktp_fetchNewApps)
    apps;

}