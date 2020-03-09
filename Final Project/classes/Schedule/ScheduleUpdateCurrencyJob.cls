global class ScheduleUpdateCurrencyJob implements Schedulable {
    global ScheduleUpdateCurrencyJob(){
    }
    global void execute (SchedulableContext sc){

        CurrencyRatesUpdate.futureUpdateRates();
    }
}
//ScheduleUpdateCurrencyJob updateCurrency = new ScheduleUpdateCurrencyJob();
//String sch = '0 0 0 * * ?';
//system.schedule('Update currency', sch, updateCurrency);
