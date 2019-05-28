global class ScheduledInvoiceEmailSender implements Schedulable {
    private Invoice__c invoice;
    private User user;

    global ScheduledInvoiceEmailSender(Id invoiceId) {
        invoice = [SELECT Id, Is_Paid__c, OwnerId, Is_Sent__c FROM Invoice__c WHERE Id = :invoiceId];
        user = [SELECT Id, Email, Name From User WHERE Id = :invoice.OwnerId];
    }

    global void execute(SchedulableContext sc) {
        if(!invoice.Is_Paid__c && !invoice.Is_Sent__c) {
            String address = user.Email;
            String subject = 'Invoice expired';
            String body = user.Name + ', invoice expired by 7 days';

            Boolean isSent = EmailManager.sendMail(address, subject, body);
            if(isSent) {
                invoice.Is_Sent__c = true;
                update invoice;
            }
        }
    }
}