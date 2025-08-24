trigger BatchErrorEventTrigger on BatchApexErrorEvent (after insert) {
    List<Error_Log__c> errorLogs = new List<Error_Log__c>();

    for (BatchApexErrorEvent event : Trigger.New) {
        System.debug('Processing BatchApexErrorEvent: ' + event);

        Error_Log__c errorLog = new Error_Log__c(
            Async_Apex_Job_Id__c = event.AsyncApexJobId,
            Message__c = event.Message,
            Stacktrace__c = event.StackTrace
        );
        errorLogs.add(errorLog);
    }

    if (!errorLogs.isEmpty()) {
        insert errorLogs;
    }
}