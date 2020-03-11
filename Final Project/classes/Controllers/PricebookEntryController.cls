public without sharing class PricebookEntryController {
    public List<PricebookEntry> PbEs {get; set;}

    public PricebookEntryController(ApexPages.StandardController controller){
        String family = ApexPages.CurrentPage().getparameters().get('car');//space %20
        String curr = ApexPages.CurrentPage().getparameters().get('curr');
        double rate = 1;
        List<Rates__c> rates = Rates__c.getall().values();
        for(Rates__c r : rates){
            if(r.name == curr){
                if(r.Rate__c!=null){
                    rate = r.Rate__c;
                }
                break;
            }
        }
        PbEs = [select product2.name, product2.Engine_Capacity__c, product2.Transmission__c, product2.Drive_unit__c, UnitPrice, Price__c
                from PricebookEntry 
                where Pricebook2.name='Standard Geely Price Book' 
                    and product2.family=:family
                order by UnitPrice ASC];
        for(PricebookEntry pb : PbEs){
            pb.product2.name = pb.product2.name.removeStart(family+' ');
            pb.Price__c = pb.UnitPrice * rate;
        }
    }
}