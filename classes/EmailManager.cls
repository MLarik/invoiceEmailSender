public class EmailManager {
    public static void sendMail(String [] addresses, String [] subjects, String [] messages, Invoice__c[] invs) {
        Messaging.SingleEmailMessage [] emails = new Messaging.SingleEmailMessage[]{};
        Integer totalMails = addresses.size();
        for(Integer i=0; i < totalMails; i++){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTargetObjectId(UserInfo.getUserId());
            email.setSubject(subjects[i]);
            email.setToAddresses(new List<String> { addresses[i] });
            email.setPlainTextBody(messages[i]);
            email.saveAsActivity = false;
            emails.add(email);
        }
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emails);
        inspectResults(results, invs);
    }
    
    private static void inspectResults(Messaging.SendEmailResult[] results, Invoice__c[] invs) {
        Integer index = 0;
        
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                invs[index].Is_Sent__c = true;
                index += 1;
            }
        }
        update invs;
    }
}