public class CurrencyCallouts {
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
        request.setEndpoint('http://www.nbrb.by/api/exrates/rates/'+code.get(curr));
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
