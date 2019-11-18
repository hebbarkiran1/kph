import { LightningElement, api } from 'lwc';
import ciscoResources from '@salesforce/resourceUrl/CiscoAppMarketplace';
//import defaultLogo from '@salesforce/resourceUrl/ciscoplaceholder';
import defaultLogo from '@salesforce/resourceUrl/Tile';


export default class MktplPublishedAppCard extends LightningElement {
    @api app;
    appsFetched = [];
    defaultAppLogo = defaultLogo;
	appResources = {
		appLogo: ciscoResources+'/images/Tile.png',
    };
    handleOpenRecordClick() {
        const selectEvent = new CustomEvent('appview', {
            detail: this.app.appId
        });
        this.dispatchEvent(selectEvent);
    }
}