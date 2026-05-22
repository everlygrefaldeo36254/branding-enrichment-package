@IsTest
public class BrandingHttpMock implements HttpCalloutMock {

    private Integer statusCode;

    public BrandingHttpMock(Integer statusCode) {
        this.statusCode = statusCode;
    }

    public HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(statusCode);
        res.setBody('Mock response');
        return res;
    }
}