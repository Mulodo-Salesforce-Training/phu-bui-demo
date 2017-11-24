trigger SPT_OfferTrigger on SPT_Offer__c (before insert, after insert) {
  
    if (Trigger.isBefore) {
        //@description when Trader offer item, trigger check is item are avaiable to offer?
        //get list item Id
        List<ID> listItemId = new List<ID>();
        for (SPT_Offer__c newOffer : Trigger.new) {
            listItemId.add(newOffer.SPT_Item__C);   
        }

        //get list item
        Map<ID,SPT_Item__c> listItem;
        try {
            listItem = new Map<ID,SPT_Item__c>([
                SELECT SPT_EndAt__c, SPT_StartAt__c, SPT_Sold__c 
                FROM SPT_Item__c 
                WHERE Id IN :listItemId
            ]);
        } catch (QueryException e) {
            System.debug(e.getMessage());
        }

        for (SPT_Offer__c newOffer : Trigger.new) {
            //check offer start time and offer end time 
            if (listItem.get(newOffer.SPT_Item__C).SPT_EndAt__c < DateTime.now() 
                || listItem.get(newOffer.SPT_Item__C).SPT_StartAt__c > DateTime.now()) {
                Trigger.new[0].addError(
                    'You can\'t offer now! Offer start at ' 
                    + listItem.get(newOffer.SPT_Item__C).SPT_StartAt__c 
                    + ' and close at ' 
                    + listItem.get(newOffer.SPT_Item__C).SPT_EndAt__c
                ); 
            }

            //check item sold?
            if (listItem.get(newOffer.SPT_Item__C).SPT_Sold__c == true) {
                Trigger.new[0].addError('Item have been sold!');
            }
        }
    } else if (Trigger.isAfter) {
        //@description send email to trader if offer create success

        String body,subject;
        MLD_Email email = new MLD_Email();
        
        //get list offer
        List<SPT_Offer__c> listOffer = new List<SPT_Offer__c>();
        try {
            listOffer = [
                SELECT SPT_Trader__r.SPT_FirstName__c, 
                    SPT_Item__r.Name, 
                    SPT_OfferPrice__c, 
                    SPT_Trader__r.SPT_Email__c
                FROM SPT_Offer__c
                WHERE Id IN :Trigger.new
            ];
        } catch (QueryException e) {
            System.debug(e.getMessage());
        }
        
        //send email for trader
        for (SPT_Offer__c offer : listOffer) {
            subject = 'Mulodo: Offer success';
            body = 'Dear ' + offer.SPT_Trader__r.SPT_FirstName__c + ', '
            + 'You have offered $' + offer.SPT_OfferPrice__c + ' for product ' + offer.SPT_Item__r.Name;
            //send email to customer
            try {
                email.sendMail(offer.SPT_Trader__r.SPT_Email__c, subject, body);
            } catch (Exception e) {
                System.debug(e.getMessage());
            }
        }
    }

}