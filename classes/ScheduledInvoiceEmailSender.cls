global class ScheduledInvoiceEmailSender implements Schedulable {
    global User owner;

    public ScheduledInvoiceEmailSender(Id invoiceOwnerId) {
        owner = [SELECT SenderEmail FROM User WHERE Id = :invoiceOwnerId];
    }

    global void execute(SchedulableContext sc) {
        // Some code
    }
}