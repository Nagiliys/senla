@isTest
global class CurrencyCalloutMock implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Cur_ID":292,"Date":"2020-02-17T00:00:00","Cur_Abbreviation":"EUR","Cur_Scale":1,"Cur_Name":"Евро","Cur_OfficialRate":2.3830}');
        response.setStatusCode(200);
        return response; 
    }
}
