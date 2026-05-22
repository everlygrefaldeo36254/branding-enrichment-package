public with sharing class BrandingService {

    private static final String BASE_URL = 'https://www.google.com/s2/favicons?domain=';
    private static final Integer DEFAULT_TIMEOUT = 10000;

    public static BrandingDTO fetchBranding(String domain) {
        validateDomain(domain);

        BrandingDTO dto = new BrandingDTO();
        dto.domain = cleanDomain(domain);

        String endpoint = buildLogoEndpoint(domain);

        try {
            HttpResponse res = BrandingHttpClient.sendGet(endpoint, DEFAULT_TIMEOUT);

           if (res.getStatusCode() >= 200 && res.getStatusCode() < 400) {
                dto.logoUrl = endpoint;
                dto.status = 'Success';
            } else {
                dto.status = 'Failed';
                dto.errorMessage = 'Google returned status code: ' + res.getStatusCode();
            }

        } catch (Exception e) {
            dto.status = 'Failed';
            dto.errorMessage = e.getMessage();
            System.debug('errorMessage ' + e.getMessage());
        }

        return dto;
    }

    public static void updateBrandingRecord(Id recordId) {
        if (recordId == null) {
            throw new AuraHandledException('Record Id is required.');
        }

        SObject recordToUpdate;
        String sourceObject;
        String domain;

        if (recordId.getSObjectType() == Account.SObjectType) {
            Account acc = [
                SELECT Id, Company_Domain__c
                FROM Account
                WHERE Id = :recordId
                LIMIT 1
            ];

            sourceObject = 'Account';
            domain = acc.Company_Domain__c;

            BrandingDTO dto = fetchBranding(domain);

            acc.Brand_Logo_URL__c = dto.logoUrl;
            acc.Branding_Status__c = dto.status;

            update acc;
            recordToUpdate = acc;

            createLog(recordId, sourceObject, dto);

        } else if (recordId.getSObjectType() == Lead.SObjectType) {
            Lead leadRecord = [
                SELECT Id, Company_Domain__c
                FROM Lead
                WHERE Id = :recordId
                LIMIT 1
            ];

            sourceObject = 'Lead';
            domain = leadRecord.Company_Domain__c;

            BrandingDTO dto = fetchBranding(domain);

            leadRecord.Brand_Logo_URL__c = dto.logoUrl;
            leadRecord.Branding_Status__c = dto.status;

            update leadRecord;
            recordToUpdate = leadRecord;

            createLog(recordId, sourceObject, dto);

        } else {
            throw new AuraHandledException('Only Account and Lead records are supported.');
        }
    }

    private static void createLog(Id recordId, String sourceObject, BrandingDTO dto) {
        Branding_Log__c log = new Branding_Log__c();
        log.Source_Record_Id__c = String.valueOf(recordId);
        log.Source_Object__c = sourceObject;
        log.Domain__c = dto.domain;
        log.Logo_URL__c = dto.logoUrl;
        log.Status__c = dto.status;
        log.Error_Message__c = dto.errorMessage;

        insert log;
    }

    private static String buildLogoEndpoint(String domain) {
            System.debug('logoEndpoint ' + BASE_URL +
                EncodingUtil.urlEncode(cleanDomain(domain), 'UTF-8') +
                '&sz=256');
            return BASE_URL +
                EncodingUtil.urlEncode(cleanDomain(domain), 'UTF-8') +
                '&sz=256';
        }

    private static String cleanDomain(String domain) {
        return domain.trim().toLowerCase();
    }

    private static void validateDomain(String domain) {
        if (String.isBlank(domain)) {
            throw new AuraHandledException('Company domain is required.');
        }
    }
}