public class CurrencyRatesUpdate {

    public static void updateCurrencySettings(Map<String, Double> curr){
        List<Rates__c> rates = Rates__c.getall().values();
        for(Rates__c rate : rates){
            rate.Rate__c=curr.get(rate.name);
        }
        update rates;
    }

    @Future(callout=true)
    public static void futureUpdateRates(){
        String[] curr = new String[]{'RUB', 'USD', 'EUR'};
        CurrencyCallouts cc = new CurrencyCallouts();
        Double rate;
        Map<String, Double> currRate = new Map<String, Double>();
        for(String c : curr){
            rate = cc.getCurrency(c);
            currRate.put(c, rate);
        }
        CurrencyRatesUpdate.updateCurrencySettings(currRate);
    }
}
