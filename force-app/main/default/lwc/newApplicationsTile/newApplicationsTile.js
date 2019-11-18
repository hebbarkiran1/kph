import { LightningElement,api,track } from 'lwc';
import myResource from '@salesforce/resourceUrl/Tile';

export default class newApplicationsTile extends LightningElement {
    @api fetchedNewApps;
    @track appLogo= myResource;

    /*get app_Logo()
    {
        
        
        alert('inside app_logo'+this.fetchedNewApps.AppLogo__c);
        this.fetchedNewApps.forEach(element => {
            var i=0;
            if(element.AppLogo__c === null || element.AppLogo__c === '')
        {
            i++;
            return  this.appLogo;
        }
        
            i++
            this.appLogo = element.AppLogo__c;
            return this.appLogo;
        });

        if(i==5)
        return 
        
    }*/
            
        
        

    
}