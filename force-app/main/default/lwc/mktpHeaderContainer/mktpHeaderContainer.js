import { LightningElement , wire, track, api} from 'lwc';

import {getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
import SMALL_PHOTO from '@salesforce/schema/User.SmallPhotoUrl'

import ciscoResources from '@salesforce/resourceUrl/CiscoAppMarketplace';

export default class mktpHeaderContainer extends LightningElement {
   appResources = {
        ciscoLogo: ciscoResources+'/images/logo-cisco-appM.png',
        ciscoFavorites: ciscoResources+'/images/heart.png',
        ciscoProfile:  ciscoResources+'/images/Cisco.png',
    };

    @api pageName;
    @track error ;
    @track email ; 
    @track name;
    @track smallPhoto;
    @ track userId= '/'+USER_ID;
    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD, EMAIL_FIELD,SMALL_PHOTO]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {
            this.email = data.fields.Email.value;
            this.name = data.fields.Name.value
            this.smallphoto = data.fields.SmallPhotoUrl.value;
        }
    }
}