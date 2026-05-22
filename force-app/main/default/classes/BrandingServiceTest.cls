@IsTest
private class BrandingServiceTest {

    @IsTest
    static void testFetchBrandingSuccess() {
        Test.setMock(HttpCalloutMock.class, new BrandingHttpMock(200));

        Test.startTest();
        BrandingDTO dto = BrandingService.fetchBranding('tesla.com');
        Test.stopTest();

        System.assertEquals('Success', dto.status);
        System.assertEquals('tesla.com', dto.domain);
        System.assertEquals('https://www.google.com/s2/favicons?domain=tesla.com&sz=256', dto.logoUrl);
    }

    @IsTest
    static void testFetchBrandingFailure() {
        Test.setMock(HttpCalloutMock.class, new BrandingHttpMock(404));

        Test.startTest();
        BrandingDTO dto = BrandingService.fetchBranding('unknown-domain-test.com');
        Test.stopTest();

        System.assertEquals('Failed', dto.status);
        System.assertNotEquals(null, dto.errorMessage);
    }

    @IsTest
    static void testUpdateAccountBranding() {
        Test.setMock(HttpCalloutMock.class, new BrandingHttpMock(200));

        Account acc = new Account(
            Name = 'Tesla',
            Company_Domain__c = 'tesla.com'
        );
        insert acc;

        Test.startTest();
        System.enqueueJob(new BrandingQueueable(acc.Id));
        Test.stopTest();

        Account updatedAcc = [
            SELECT Brand_Logo_URL__c, Branding_Status__c
            FROM Account
            WHERE Id = :acc.Id
        ];

        System.assertEquals('Success', updatedAcc.Branding_Status__c);
        System.assertEquals('https://www.google.com/s2/favicons?domain=tesla.com&sz=256',
            updatedAcc.Brand_Logo_URL__c
            );

        Branding_Log__c logRecord = [
            SELECT Status__c, Domain__c, Source_Object__c
            FROM Branding_Log__c
            WHERE Source_Record_Id__c = :String.valueOf(acc.Id)
            LIMIT 1
        ];

        System.assertEquals('Success', logRecord.Status__c);
        System.assertEquals('tesla.com', logRecord.Domain__c);
        System.assertEquals('Account', logRecord.Source_Object__c);
    }
    @IsTest
        static void testFetchBrandingMissingDomain() {
            try {
                BrandingService.fetchBranding('');
                System.assert(false, 'Expected exception was not thrown.');
            } catch (AuraHandledException e) {
                System.assert(true);
            }
        }
}