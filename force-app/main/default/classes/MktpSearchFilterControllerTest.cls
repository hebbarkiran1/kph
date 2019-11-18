@IsTest
public with sharing class MktpSearchFilterControllerTest {
    public MktpSearchFilterControllerTest() {

    }

 


    @IsTest(SeeAllData=true)
    public static void getPublishedAppFiltersTest(){

                Test.StartTest();

        List<Filters> filters = mktpPublishedAppSearchFiltersController.getPublishedAppFilters();
        Test.StopTest();

        //System.assert(filters.con);

    }




}