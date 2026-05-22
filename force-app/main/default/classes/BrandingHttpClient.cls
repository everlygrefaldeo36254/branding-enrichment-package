public with sharing class BrandingHttpClient {

    public static HttpResponse sendGet(String endpoint, Integer timeoutMs) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        System.debug('Endpoint ' + endpoint);
        req.setMethod('GET');
        req.setTimeout(timeoutMs);
        

        Http http = new Http();
        return http.send(req);
    }
}