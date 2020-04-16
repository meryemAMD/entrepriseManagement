trigger SendMailVacationRequest on VacationRequest__c (after insert) {
    String address;
    String subject = 'Confirmation de demande de congé'; 
    String body;

    List<String> Ids = new List<String>();

    for(VacationRequest__c vacation : trigger.new){
        Ids.add(vacation.employee__c);
    }
    List<Employee__c> employees = [SELECT Name from employee__c where Id in :Ids];
    for(Employee__c employee : employees){
        address = employee.name+'@gmail.com';
        system.debug(address) ;
        body = 'Bonjour '+employee.Name+', \n Nous tenons à vous informer que votre demande de congé est bien enregistré.\n Cordilement';
        sendMail(address , subject , body);
    }


    public void sendMail(String address, String subject, String body) {
        // Create an email message object
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {address};
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        // Pass this email message to the built-in sendEmail method 
        // of the Messaging class
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
                                 new Messaging.SingleEmailMessage[] { mail });
        
        // Call a helper method to inspect the returned results
        inspectResults(results);
    }
    
    // Helper method
    private static Boolean inspectResults(Messaging.SendEmailResult[] results) {
        Boolean sendResult = true;
        
        // sendEmail returns an array of result objects.
        // Iterate through the list to inspect results. 
        // In this class, the methods send only one email, 
        // so we should have only one result.
        for (Messaging.SendEmailResult res : results) {
            if (res.isSuccess()) {
                System.debug('Email sent successfully');
            }
            else {
                sendResult = false;
                System.debug('The following errors occurred: ' + res.getErrors());                 
            }
        }
        
        return sendResult;
    }
}