import { LightningElement, track,wire, api } from 'lwc';
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';
import searchApps from '@salesforce/apex/mktpPublishedAppSearchController.searchApps';
import ciscoResources from '@salesforce/resourceUrl/CiscoAppMarketplace';


const DELAY = 200;

export default class MKTPPublishedAppSearchbox extends LightningElement {
    @track searchTerm;
    @api PageName;
    @api hostPage;
    @wire(CurrentPageReference) pageRef;
    @track apps=[];
    errorMsg='';
    @track searchFired = false;
    appResources = {
		searchLogo: ciscoResources+'/images/search-logo.svg',
    };

    connectedCallback()
    {
        if(this.hostPage === 'search')
        {
            this.searchTerm = decodeURIComponent(window.location.href.substr(window.location.href.lastIndexOf('/')+1));
        }
     }

    buildQuerySuggestions()
    {
        if(this.searchTerm !== '')
        { 
            searchApps({searchTerm:this.searchTerm,
                appliedFilters:'' })
			.then(result => {
				this.apps = result;
                this.errorMsg = undefined;
                this.searchFired =true; 
			})
			.catch(error=>{
                this.errorMsg = error.body.message;
                this.apps = undefined;
                this.searchFired =true; 
            });
        }
        else
        {
            this.searchFired = false;
        }
    }

    get hasResults() {
		if(!this.apps || this.apps.length <1)
			return false;
		return true;
    }
    
    handleFocus(event)
    {
        this.searchTerm = event.target.value;
        if(this.searchTerm !== "")
        {
            window.clearTimeout(this.delayTimeout);
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                this.buildQuerySuggestions();
            }, DELAY); 
        }
    }

    handleKeyUp(event){

        this.searchTerm = event.target.value;
        const isEnterKey = event.keyCode === 13;
        if (isEnterKey) {

            if(this.searchTerm === "")
            {
                this.errorMsg = "Please provide a search term";
                return;
            }
            if(this.hostPage !=='search')
            {
                window.location.href = window.location.href.concat('search/',encodeURIComponent(this.searchTerm));
            }
            else
            {
                window.history.pushState("","Search Results for " + this.searchTerm,encodeURIComponent(this.searchTerm));
                this.searchFired=false;
                fireEvent(this.pageRef, 'handleSearch', encodeURIComponent(this.searchTerm));
            }
        }

        if (event.keyCode !== 27 && event.keyCode !== 37 && event.keyCode !== 38 && event.keyCode !== 39 && event.keyCode !== 40 && event.keyCode !== 13) {
            window.clearTimeout(this.delayTimeout);
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                this.buildQuerySuggestions();
            }, DELAY);
        }    
    }
  
    handleKeyDown(event)
    {
        if(event.keyCode ===27)
        {
            this.searchFired=false;
        }
    }


    handleSelection(event)
    {
        this.searchTerm = event.target.innerText;

        if(this.hostPage !=='search')
        {
            window.location.href = window.location.href.concat('search/',encodeURIComponent(this.searchTerm));
        }
        else
        {
            window.history.pushState("","Search Results for " + this.searchTerm,encodeURIComponent(this.searchTerm));
            this.searchFired=false;
            fireEvent(this.pageRef, 'handleSearch', encodeURIComponent(this.searchTerm));
        }
    }

  
}