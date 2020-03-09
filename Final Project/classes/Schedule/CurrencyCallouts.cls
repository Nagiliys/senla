public class CurrencyCallouts {
//https://salesforce.stackexchange.com/questions/13282/updating-multi-currency-rates-from-apex
//RUB   298
//USD   145
//EUR   292
    private map<String, String> code;
    public CurrencyCallouts(){
        code = new Map<String, String>();
        code.put('EUR', '292');
        code.put('RUB', '298');
        code.put('USD', '145');
    }
    public Double getCurrency(String curr){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://www.nbrb.by/api/exrates/rates/'+code.get(curr));//http://www.nbrb.by/API/ExRates/Rates?Periodicity=0
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        Double rt = null;

        if (response.getStatusCode() == 200) {
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Integer scale = (Integer) results.get('Cur_Scale');
            Double rate = (Double) results.get('Cur_OfficialRate');
            rt = 1/(rate/scale);
        }
        return rt;
    }
}
