public with sharing class BrandingController {

    @AuraEnabled
    public static void enrichBranding(Id recordId) {

        if(recordId == null) {
            throw new AuraHandledException(
                'Record Id is required.'
            );
        }

        System.enqueueJob(
            new BrandingQueueable(recordId)
        );
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccount(Id recordId) {

        return [
            SELECT
                Id,
                Name,
                Company_Domain__c,
                Brand_Logo_URL__c,
                Branding_Status__c
            FROM Account
            WHERE Id = :recordId
            LIMIT 1
        ];
    }
}