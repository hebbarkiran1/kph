public with sharing class mktpHomePageBannerImageController {
 
     @AuraEnabled 
    public static List<SubheaderWrapper> getBannerImageParameters(){
         List<SubheaderWrapper> wrapperList = new List<SubheaderWrapper>();
        String pathPrefix = 'https://appxchange-developer-edition.na113.force.com/CiscoAppEx';//Site.getPathPrefix();
        User u = [SELECT Id, Name, ProfileId, Profile.Name, UserType 
                  FROM User 
                  WHERE ID =: UserInfo.getUserId()
                  limit 1];
        boolean isUserLoggedIn;
        if(u.UserType == 'Guest'){
            isUserLoggedIn = true;
        }else{
            isUserLoggedIn = false;
        }
        system.debug('pathPrefix >>' + pathPrefix +'isUserLoggedIn' + isUserLoggedIn);
        SubheaderWrapper sub= new SubheaderWrapper(pathPrefix, isUserLoggedIn);
        wrapperList.add(sub); 
        return wrapperList;
    }
     
       
      public class SubheaderWrapper{
        @AuraEnabled public String sitePathPrefix{get;set;}
        @AuraEnabled public Boolean isUserLoggedIn{get;set;}
        
        public SubheaderWrapper(String sitePathPrefix,Boolean isUserLoggedIn){
            this.sitePathPrefix = sitePathPrefix;
            this.isUserLoggedIn = isUserLoggedIn;
        }
    }
}