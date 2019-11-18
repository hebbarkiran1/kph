import { LightningElement, wire } from 'lwc';
import fetchRecApps from '@salesforce/apex/RecommendedAppsController.fetchRecApps'
import myResource from '@salesforce/resourceUrl/Tile';

export default class mktpRecApplications extends LightningElement {
    appLogo = myResource;
    @wire(fetchRecApps)
    apps;

}