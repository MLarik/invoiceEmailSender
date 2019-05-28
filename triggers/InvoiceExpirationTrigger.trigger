trigger InvoiceExpirationTrigger on Invoice__c (after insert) {
    Invoice__c[] invoices = [SELECT Id, Due_Date__c, OwnerId, Name FROM Invoice__c
                             WHERE Id IN :Trigger.new];

    for(Invoice__c invoice : invoices) {
        Datetime due_date = invoice.Due_Date__c.addDays(7);
        String due_date_str = '' + due_date.second() + ' ' + due_date.minute() + ' '
                              + due_date.hour() + ' ' + due_date.day() + ' ' + due_date.month() + ' ?';
        ScheduledInvoiceEmailSender emailSender = new ScheduledInvoiceEmailSender(invoice.Id);

        String jobId = System.schedule(invoice.Name + '(' + invoice.id + ')' + ' send email in 7 days', due_date_str, emailSender);
    }
}