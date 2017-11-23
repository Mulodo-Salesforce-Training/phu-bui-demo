public class SPT_ItemCX {
    public final SPT_Item__c item;
    public String result = 'This is default resut';
    
    // The extension constructor initializes the private member
    // variable item by using the getRecord method from the standard
    // controller.
    public SPT_ItemCX(ApexPages.StandardController standardController) {
        this.item = (SPT_Item__c)standardController.getRecord();
    }

    /*
    @author Phu Bui
    @date 23/11/2017
    @description get all offer of item to show trader name and offer price
    @return List<SPT_Offer__c>
    */
    public List<SPT_Offer__c> getAllOffer() {
    	List<SPT_Offer__c> listOffer = new List<SPT_Offer__c>();
    	try {
            listOffer = [SELECT SPT_Trader__r.SPT_FirstName__c, SPT_OfferPrice__c, CreatedDate
            			FROM SPT_Offer__c
            			WHERE SPT_Item__c = :this.item.Id
            			LIMIT 10];
    	} catch (QueryException e) {
    		//return e.getMessage();
    	}
        return listOffer;
    }

    /* return some text to say hello user
    */
    public String getGreeting() {
        return 'Hello there';
    }
}