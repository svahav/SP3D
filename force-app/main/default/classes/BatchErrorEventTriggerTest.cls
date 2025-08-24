@isTest
public class BatchErrorEventTriggerTest {
    @isTest
    static void testBatchErrorEventTrigger() {
        // Create a list to hold the platform events
        List<BatchApexErrorEvent> events = new List<BatchApexErrorEvent>();

        // Create a BatchApexErrorEvent instance with test data
        BatchApexErrorEvent event = new BatchApexErrorEvent();
        event.AsyncApexJobId = '707xx0000000001AAA'; // Sample Async Apex Job ID
        event.Message = 'Test error message';
        event.StackTrace = 'Test stack trace';

        events.add(event);

        // Use Test.startTest() and Test.stopTest() to simulate the event publishing
        Test.startTest();
        // Publish the platform event
        List<Database.SaveResult> results = EventBus.publish(events);
        Test.stopTest();

        // Verify that the event was published successfully
        System.assertEquals(1, results.size(), 'One event should have been published');
        System.assert(results[0].isSuccess(), 'Event publishing failed');

        // Query for the Error_Log__c record created by the trigger
        List<Error_Log__c> errorLogs = [
            SELECT Async_Apex_Job_Id__c, Message__c, Stacktrace__c
            FROM Error_Log__c
            WHERE Async_Apex_Job_Id__c = :event.AsyncApexJobId
        ];

        // Verify that the Error_Log__c record was created
        System.assertEquals(1, errorLogs.size(), 'One Error_Log__c record should have been created');
        Error_Log__c errorLog = errorLogs[0];

        // Assert that the fields match the event data
        System.assertEquals(event.AsyncApexJobId, errorLog.Async_Apex_Job_Id__c, 'Async Apex Job IDs do not match');
        System.assertEquals(event.Message, errorLog.Message__c, 'Error messages do not match');
        System.assertEquals(event.StackTrace, errorLog.Stacktrace__c, 'Stack traces do not match');
    }
}