public with sharing class StatActionController {

    @AuraEnabled(cacheable=true)
    public static Opportunity getStatValue(String oppId) {
    
        Opportunity opp =  [
            SELECT
                isStat__c,
                Surgery_Date__c
            FROM
                Opportunity
            WHERE
                Id = :oppId
        ];

        if (opp.Surgery_Date__c == null) {
            throw new AuraHandledException('A Surgery Date is required to make an opportunity STAT.');
        }

        return opp;
    }

    @AuraEnabled
    public static void updateStatValue(String oppId, Boolean statVal) {
        Opportunity opp = new Opportunity(
            Id = oppId,
            isStat__c = statVal
        );
        update opp;
    }
}