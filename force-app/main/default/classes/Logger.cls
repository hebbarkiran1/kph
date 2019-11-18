public with sharing class Logger {
    /*******************************************************************************************
    @author         Shankar Mallick
    @date           08 Nov,2019
    @description:   This class logs the exceptions in the Log__c Object
    Revision(s):    SM,      08 Nov 2019,                      Fixed bug with save mechanism
    **********************************************************************************************/
    // Declaring the variables
    private static List<StackTrace> stack = new List<StackTrace>();
    private static Integer currentLevel = 0;
    private static List<Log__c> debugList = new List<Log__c>();
    private static List<Log__c> exceptionList = new List<Log__c>();
    private static Integer sequence = 0;
    private static Boolean debugLogEnabled;
    private static Boolean exceptionLogEnabled;
    private final static String EXCEPTIONTYPE = 'EXCEPTION'; 
    private final static String DEBUGTYPE = 'DEBUG'; 


    // This method should be called when entering every method in a class. The method will initiate a stacktrace which will have the level of debug info along with the function name and object name
    static public void push(string functionName, string objectName){        
        stack.add(new StackTrace(currentLevel, functionName, objectName));
        currentLevel++;
    }
    

    // This method should be called when exiting every method in a class. This method will remove the debuginfo along with the functionName and objectName
    static public void pop(){

        if(currentLevel > 0){
            currentLevel--;
            if(stack.size() > 0){
                stack.remove(stack.size() -1);
            }
        }
        
        if(currentLevel==0){
            
            String debugListString = JSON.serialize(debugList);
            String exptListString = JSON.serialize(exceptionList);
            writeLogsToDatabase(exptListString, debugListString);
            debugList = new List<Log__c>();
            exceptionList = new List<Log__c>();
        }       
    }


    //This method will fire asynchronously as it uses future call. The method will insert the Log record with debug info and exception info (if necessary) depending on the custom setting of the current user profile.
    @future
    static private void writeLogsToDatabase(string exptListString, string debugListString){
        // Get the values of debugLogEnabled and exceptionLogEnabled
        Map<String, LogParameters__mdt> mapLogParameters = new Map<String, LogParameters__mdt>();
        for(LogParameters__mdt logParams : [Select DeveloperName, BooleanValue__c FROM LogParameters__mdt]){
            mapLogParameters.put(logParams.DeveloperName, logParams);
        }
        debugLogEnabled = mapLogParameters.get('DebugLogEnabled').BooleanValue__c;
        exceptionLogEnabled = mapLogParameters.get('ExceptionLogEnabled').BooleanValue__c;
        system.debug('exceptionLogEnabled :: ' + exceptionLogEnabled);
        system.debug('debugLogEnabled :: ' + debugLogEnabled);

        List<Log__c> debugListParsed = (List<Log__c>)JSON.deserialize(debugListString,  List<Log__c>.class);
        List<Log__c> exceptListParsed = (List<Log__c>)JSON.deserialize(exptListString,  List<Log__c>.class);
        //if debug custom setting is on         
        if(debugLogEnabled){
            insert debugListParsed;
        }
        //if exception custom setting is on
        if(exceptionLogEnabled){
            insert exceptListParsed;
        }    
    }

    // This method resets the debug log by re-initiating the stack trace and setting the current debug level to 0
    static public void popAll(){
        stack = new List<StackTrace>();
        currentLevel = 0;
        pop();          
    }

    // This method is called by methods which needs to capture a debug statement into Salesforce. The string that needs to be displayed in the debug log is passed to this method and is added to the list of debug logs that will be inserted into Salesforce
    static public void debug(string debugString){

        System.debug(debugString);
        Log__c log = new Log__c();
        log.StackTrace__c = getStackTrace();
        log.Limits__c = getLimits();
        log.Message__c = debugString;
        log.ExceptionType__c = DEBUGTYPE;
        log.User__c = Userinfo.getUserId();
        log.Sequence__c = sequence;
        debugList.add(log);
        sequence++;
    }

    //Similar to the debug method, this method is called by methods which needs to capture a exception statment into Salesforce. The string that needs to be displayed in the debug log is passed to this method and is added to the list of exception logs that will be inserted into Salesforce
    static public void debugException(Exception ex){
        string exceptionInfo = ex.getMessage() + ' stack: ' + ex.getStackTraceString();
        Log__c log = new Log__c();
        log.StackTrace__c = getStackTrace();
        log.Limits__c = getLimits();
        log.Message__c = exceptionInfo;
        log.ExceptionType__c = EXCEPTIONTYPE;
        log.User__c = Userinfo.getUserId();
        log.ExceptionLine__c = ex.getLineNumber();
        log.ExceptionType__c = ex.getTypeName();
        log.Sequence__C = sequence;
        exceptionList.add(log);
        sequence++;
    }

    //This methods uses the Limit() method in Salesforce to call all the limits reached in the current execution context againsts the governor limits set by Salesforce.
    static private string getLimits(){        
        string limitstring = '';
        //limitstring += 'Script Limits: '+ Limits.getScriptStatements() + '/' + Limits.getLimitScriptStatements() +'\n';
        limitstring += 'Query Limits: '+ Limits.getQueries() + '/' + Limits.getLimitQueries() +'\n';
        limitstring += 'DML Rows Limits: '+Limits.getDMLRows()+'/'+Limits.getLimitDMLRows()+'\n';
        limitstring += 'Heap Size Limits: '+Limits.getHeapSize()+'/'+Limits.getLimitHeapSize()+'\n';
        limitstring += 'Query Return Limits: '+Limits.getQueryRows()+'/'+Limits.getLimitQueryRows()+'\n';

        return limitstring;

    }

    // returns the stacktrace string that will contain the stack trace entries along with the trace level
    static private string getStackTrace(){
        string retVal ='';
        if (stack != null && stack.size() >0){
            String spaces='                                                                ';       
            for (StackTrace se : stack)   {

                Integer endIndex = 3 * se.currentLevel;
                if (endIndex >= spaces.length())
                    endIndex = spaces.length()-1;
                //retVal += spaces.substring(0,endIndex)+se.getEntry()+'\n';
                retVal += spaces.substring(0,endIndex)+'\n';
            }
        }
        return retVal;
    }

    // This is our wrapper/container class
    public class StackTrace {
        /**
        * Takes an Exception which may have a cause exception inside it, and builds a string of all messages + traces
        * inside it by calling getCause() until there are no more.
        *
        * @param e an Exception
        * @return the type, messages, and stack traces from e and all nested Exceptions inside it
        */
        public Integer currentLevel {get; set;}
        public String functionName {get; set;}
        public String objectName {get; set;}
        public StackTrace (Integer cl, String fn, String objn){
            currentLevel = cl;
            functionName = fn;
            objectName = objn;
        }
    }
}