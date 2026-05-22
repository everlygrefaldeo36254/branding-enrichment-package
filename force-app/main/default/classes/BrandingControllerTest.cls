@IsTest
private class BrandingControllerTest {

    @IsTest
    static void testGetAccount() {

        Account acc = new Account(
            Name = 'Nvidia',
            Company_Domain__c = 'nvidia.com',
            Brand_Logo_URL__c = 'https://example.com/logo.png',
            Branding_Status__c = 'Success'
        );

        insert acc;

        Test.startTest();

        Account result =
            BrandingController.getAccount(acc.Id);

        Test.stopTest();

        System.assertEquals(acc.Id, result.Id);
        System.assertEquals(
            'nvidia.com',
            result.Company_Domain__c
        );

        System.assertEquals(
            'Success',
            result.Branding_Status__c
        );
    }

    @IsTest
    static void testEnrichBranding() {

        Test.setMock(
            HttpCalloutMock.class,
            new BrandingHttpMock(200)
        );

        Account acc = new Account(
            Name = 'Nvidia',
            Company_Domain__c = 'nvidia.com'
        );

        insert acc;

        Test.startTest();

        BrandingController.enrichBranding(acc.Id);

        Test.stopTest();

        Account updatedAcc = [
            SELECT
                Brand_Logo_URL__c,
                Branding_Status__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assertEquals(
            'Success',
            updatedAcc.Branding_Status__c
        );
    }

    @IsTest
    static void testEnrichBrandingMissingRecordId() {

        try {

            BrandingController.enrichBranding(null);

            System.assert(
                false,
                'Expected exception was not thrown.'
            );

        } catch (AuraHandledException e) {

            System.assert(true);
        }
    }
}