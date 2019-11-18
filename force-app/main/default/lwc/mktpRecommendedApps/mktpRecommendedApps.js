import { LightningElement,wire,track } from 'lwc';
import fetchRecApps from '@salesforce/apex/RecommendedAppsController.fetchRecApps';
import Tile from '@salesforce/resourceUrl/Tile';

export default class mktpRecommendedApps extends LightningElement {
    @track Image = Tile;

    @wire(fetchRecApps)
    recApps;

    @track temp=[1,2,3,4,5];
}