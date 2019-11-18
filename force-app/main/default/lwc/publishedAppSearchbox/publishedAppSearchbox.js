import { LightningElement, track,wire } from 'lwc';
import { fireEvent } from 'c/pubsub';
import { CurrentPageReference } from 'lightning/navigation';


export default class PublishedAppSearchbox extends LightningElement {
    @track searchTerm='';

    @wire(CurrentPageReference) pageRef;


    handleSearchTerm(event)
    {
        this.searchTerm = event.target.value;
    }

    handleSearch(){
        if(this.searchTerm==="")
		{
			this.errorMsg = "Please use a keyword";
			return;
        }
        
		let searchUrl = "?searchterm=" + this.searchTerm;
        window.history.pushState("","Home",searchUrl);
        
        fireEvent(this.pageRef, 'handleSearch', this.searchTerm);
    }
}