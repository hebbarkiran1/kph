import { LightningElement,wire ,track,api} from 'lwc';
import getImageDetails from '@salesforce/apex/mktpHomePageBannerImageController.getBannerImageParameters';

export default class mktpHomePageBannerImage extends LightningElement {
   @api showforloggedinuser;
    @api shutterstockImage;
    @track isguest;
    @track pathPrefix;
    @track urlbanner;
    @track error;
    @api defaultImage;

    @wire(getImageDetails)imgDetails;

    
}