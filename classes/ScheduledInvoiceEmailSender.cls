global class ScheduledInvoiceEmailSender implements Database.Batchable<sObject>, Schedulable {

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Name, Owner.Email, Is_Sent__c, Due_Date__c FROM Invoice__c ' +
            'WHERE Is_Sent__c = false AND Is_Paid__c = false'
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Invoice__c> records) {
        String[] addresses = new String[]{};
        String[] subjects = new String[]{};
        String[] messages = new String[]{};
        Invoice__c[] invoices = new Invoice__c[]{};

        for ( Invoice__c inv : records ) {
            Datetime finalDate = inv.Due_Date__c.addDays(7);
            if(Datetime.now() >= finalDate) {
                addresses.add(inv.Owner.Email);
                subjects.add('Invoice expired');
                messages.add(inv.Name + ' invoice expired by 7 days');
                invoices.add(inv);
            }
        }
        
        EmailManager.sendMail(addresses, subjects, messages, invoices);
    }    
    global void finish(Database.BatchableContext bc) {}

    global void execute(SchedulableContext sc) {
        Type t = Type.forName('ScheduledInvoiceEmailSender');
        Database.Batchable< sObject > batchClass = ((Database.Batchable< sObject >) t.newInstance());
        Database.executeBatch(batchClass);
    }
}