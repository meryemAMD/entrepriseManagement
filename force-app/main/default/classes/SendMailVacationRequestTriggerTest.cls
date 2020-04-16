@isTest
public class SendMailVacationRequestTriggerTest {
    @isTest
    public static void SendMailVacationRequestTriggerTest() {
        Employee__c employee = new Employee__c();
        employee.name = 'meryemahmada.97';
        insert employee;
        VacationRequest__c vc = new VacationRequest__c();
        vc.name = 'congé';
        vc.employee__c = employee.id;
        insert vc;
    }
}
