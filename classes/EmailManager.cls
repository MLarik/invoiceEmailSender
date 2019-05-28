public class EmailManager {
    public static Boolean sendMail(String address, String subject, String body) {
        List<Messaging.SingleEmailMessage>  myEmails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<String> toAddresses = new List<String> {address};
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        
        myEmails.add(mail);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(myEmails);
        
        return inspectResults(results);
    }
    
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        
        for (Messaging.SendEmailResult res : results) {
            if (!res.isSuccess()) {
                sendResult = false;
            }
        }      
        return sendResult;
    }
}