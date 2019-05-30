global class ScheduledInvoiceEmailSender implements Database.Batchable<sObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Owner.Email, Is_Sent__c, Due_Date__c FROM Invoice__c' +
            'WHERE Is_Sent__c = false AND Is_Paid__c = false'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Invoice__c> records) {
        for ( Invoice__c inv : records ) {
            Datetime finalDate = inv.Due_Date__c.addDays(7);
            if(Datetime.now() >= finalDate) {
                Boolean isSent = EmailManager.sendMail(inv.Owner.Email, 'Invoice expired',
                                                       inv.Name + 'invoice expired by 7 days');
                if(isSent) {
                    inv.Is_Sent__c = true;
                    update inv;
                }
            }
        }
    }    
    global void finish(Database.BatchableContext bc) {}

    global void execute(SchedulableContext sc) {
        Type t = Type.forName('ScheduledInvoiceEmailSender');
        Database.Batchable< sObject > batchClass = ((Database.Batchable< sObject >) t.newInstance());
        Database.executeBatch(batchClass);
    }
}