import { LightningElement,track,api } from 'lwc';
import IMAGAE_LOCATION from '@salesforce/resourceUrl/CiscoAppMarketPlaceHomePage'

export default class MktpAppBannerHomePage extends LightningElement {
    @api bannerImageName;
    @track bannerImageURL;
    @track bannerName;
    
    connectedCallback() {
      this.bannerImageURL=IMAGAE_LOCATION+'/images/'+this.bannerImageName;
      this.bannerName = this.bannerImageName;
      }
  
 }