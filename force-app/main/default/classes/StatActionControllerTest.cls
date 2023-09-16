@isTest
private with sharing class StatActionControllerTest {
   
    @IsTest
    static void getStatValueTest(){
        
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            isStat__c = false,
            StageName = 'Awaiting Deposit',
            CloseDate = Date.today(),
            Procedure_Side__c = 'Left',
            Procedure_Type__c = 'Hip'
        );
        insert opp;

        String errMessage;
        Opportunity returnOpp = new Opportunity();
        try {
            returnOpp = StatActionController.getStatValue(opp.Id);
        }
        catch (Exception ex) {
            errMessage = ex.getMessage();
        }
        System.debug(errMessage);
        System.assert(errMessage != null, 'No error thrown.');
        opp.Surgery_Date__c = Date.today();
        update opp;

        returnOpp = StatActionController.getStatValue(opp.Id);
        System.debug(returnOpp);
        System.assert(returnOpp.Id != null, 'No opportunity found.');

        StatActionController.updateStatValue(opp.Id, true);
        returnOpp = [
            SELECT isStat__c
            FROM Opportunity
            WHERE Id = :opp.Id
        ];
        System.debug(returnOpp);
        System.assertEquals(true, returnOpp.isStat__c, 'Stat field not updated.');
    }
}