public inherited sharing class LWCExampleController {

/* --- SM:Commenting to make modification to the object    
    @AuraEnabled
    public static ContentVersion saveFile(Id idParent, String strFileName, String base64Data) {
        fileUploadTest(idParent,strFileName,base64Data);
        // Decoding base64Data
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        // inserting file
        ContentVersion cv = new ContentVersion();
        cv.Title = strFileName;
        cv.PathOnClient = '/' + strFileName;
        cv.FirstPublishLocationId = idParent;
        cv.VersionData = EncodingUtil.base64Decode(base64Data);
        cv.IsMajorVersion = true;
        //Insert cv;
        return cv;
    }

    @AuraEnabled
    public static list<contentversion> releatedFiles(Id idParent){
        list<id> lstConDocs = new list<id>();
        for(ContentDocumentLink cntLink : [Select Id, ContentDocumentId From ContentDocumentLink Where LinkedEntityId =:idParent]) {
            lstConDocs.add(cntLink.ContentDocumentId);
        }
        if(!lstConDocs.isEmpty()) {
            return [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :lstConDocs];
        }
        else {
            return null;
        }
     
    }
  

 @AuraEnabled
    public static void fileUploadTest(Id idParent,String strFileName, String base64Data)
    {
      App_Marketing_Content__c marketingContent = [SELECT Id,Name, File_Type__c FROM App_Marketing_Content__c WHERE id =: idParent limit 1 ];
        
        String contentType='video/mp4';
        if(marketingContent!=null && marketingContent.File_Type__c=='PDF'){
            contentType='application/pdf';
        }
        String attachmentBody = EncodingUtil.urlDecode(base64Data,'UTF-8');
        String formattedDateString = Datetime.now().formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String secret = 'ePtdhc1rPtbTw7gE2EuXY1hDcJ4n0JQB9G0Yu20t';
        String key = 'AKIAJVA2TBT6WM6QRD5A';
        String bucketname = 'appmarketingcontents';
        String host =  's3.amazonaws.com'; //'s3-us-west-1.amazonaws.com';
        String method = 'PUT';
        String filename =  strFileName;
        

        String uploadContentURL = 'https://' + bucketname + '.' + host + '/'  + filename;
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndpoint('https://' + bucketname + '.' + host + '/'  + filename);
        req.setHeader('Host', bucketname + '.' + host);
        req.setHeader('Content-Length', String.valueOf(attachmentBody.length()));
        req.setHeader('Content-Encoding', 'UTF-8');
        req.setHeader('Content-type', contentType);
        req.setHeader('Connection', 'keep-alive');
        req.setHeader('Date', formattedDateString);
        req.setHeader('ACL', 'public-read');
        req.setBodyAsBlob(EncodingUtil.base64Decode(attachmentBody));

        String stringToSign = 'PUT\n\n' +
            contentType + '\n' +
            formattedDateString + '\n' +
            '/' + bucketname + '/' + filename; // '/' + bucketname +

        String encodedStringToSign = EncodingUtil.urlEncode(stringToSign, 'UTF-8');
        Blob mac = Crypto.generateMac('HMACSHA1', blob.valueof(stringToSign),blob.valueof(secret));
        String signed = EncodingUtil.base64Encode(mac);
        String authHeader = 'AWS' + ' ' + key + ':' + signed;
        req.setHeader('Authorization',authHeader);
        String decoded = EncodingUtil.urlDecode(encodedStringToSign , 'UTF-8');

        Http http = new Http();
        HTTPResponse res = http.send(req);
        System.debug('*Resp:' + String.ValueOF(res.getBody()));
        System.debug('RESPONSE STRING: ' + res.toString());
        System.debug('RESPONSE STATUS: ' + res.getStatus());
        System.debug('STATUS_CODE: ' + res.getStatusCode());
        if(res.getStatusCode()==200){

          App_Marketing_Content__c appContent = new App_Marketing_Content__c();
          appContent.id= idParent;
          appContent.External_URL__c=uploadContentURL;
          system.debug('app >> '+ appContent);
          update appContent;
           
       }
    } 
------*/    
}