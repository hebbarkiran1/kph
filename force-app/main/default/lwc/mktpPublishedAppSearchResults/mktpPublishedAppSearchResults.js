import { NavigationMixin, CurrentPageReference } from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';
import { loadStyle } from 'lightning/platformResourceLoader';
import ciscoResources from '@salesforce/resourceUrl/CiscoAppMarketplace';
import { LightningElement, track, wire } from 'lwc';
import searchApps from '@salesforce/apex/mktpPublishedAppSearchController.searchApps';

export default class mktpPublishedAppSearchResults extends NavigationMixin(LightningElement) {
	@track searchTerm = '';
	@track apps;
	@track errorMsg;
	@track appliedFilter='';
	wiredResults;

	@wire(CurrentPageReference) pageRef;

	// [ashwani]running into caching issue with Wire service if appfilters is an array.
	@wire(searchApps,{searchTerm:'$searchTerm',appliedFilters:'$appliedFilter' })
	getapps(result)
	{
		this.wiredResults = result;
		const {data, error} = result;
		if(data)
		{
			this.apps = data;
			this.errorMsg = undefined;
		}
		else if(error)
		{
			this.errorMsg = error.body.message;
			this.apps =undefined
		}
	}

	firesearch()
	{
		// searchApps({searchTerm:this.searchTerm,
		// 	filtersToApply:this.appliedFilter })
		// 	.then(result => {
		// 		this.apps = result;
		// 		this.errorMsg = undefined;
		// 		
		// 	})
		// 	.catch(error=>{
		// 		this.errorMsg = error.body.message;
		// 		this.apps = undefined;
		// 	});
		//return refreshApex(this.wiredResults);
		
	}
	
	connectedCallback() {
		loadStyle(this, ciscoResources + '/Ciscodesign.css');

		this.searchTerm = decodeURIComponent(window.location.href.substr(window.location.href.lastIndexOf('/')+1));
		//this.firesearch();

		registerListener('handleSearch', this.handleSearch, this);
		registerListener('filterchange', this.handlefilterchange, this);
		
	}

	disconnectedCallback() {
		// unsubscribe from filterchange event
		unregisterAllListeners(this);
	}

	handleSearch(event) {
		if(event)
		{
			this.searchTerm=decodeURIComponent(event);
		}
	}
	
	handlefilterchange(event)
	{
		if(event)
		{
			// Need to conver to JSON so that the wire service can recognize that the value has changed.
			this.appliedFilter = JSON.stringify(event);
			this.firesearch();
		}
	}

	get hasResults() {
		if(!this.apps || this.apps.length <1)
			return false;
		return true;
	}

	handleAppView(event) {
		// Get app record id from appview event
		const appId = event.detail;
		// Navigate to app record page
		this[NavigationMixin.Navigate]({
			type: 'standard__recordPage',
			attributes: {
				recordId: appId,
				objectApiName: 'PublishedApp__c',
				actionName: 'view',
			},
		});
    }
}