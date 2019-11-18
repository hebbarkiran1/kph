import { LightningElement,wire,track } from 'lwc';
import fetchRecApps from '@salesforce/apex/RecommendedAppsController.fetchRecApps';
import Tile from '@salesforce/resourceUrl/Tile';

export default class mktpRecAppCard extends LightningElement {
    @track Image = Tile;

    @wire(fetchRecApps)
    recApps;

    
}