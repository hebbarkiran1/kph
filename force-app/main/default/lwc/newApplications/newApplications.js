import { LightningElement,wire,track } from 'lwc';
import fetchNewApps from '@salesforce/apex/newApplicationsController.fetchNewApps';
import Tile from '@salesforce/resourceUrl/Tile';

export default class newApplications extends LightningElement {
    @track Image = Tile;

    @wire(fetchNewApps)
    newApps;

    @track temp=[1,2,3,4,5];
}