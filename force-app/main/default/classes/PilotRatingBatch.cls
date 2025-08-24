global class PilotRatingBatch implements Database.Batchable<SObject>, Database.Stateful, Database.RaisesPlatformEvents {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Start method called - Initializing Batch');
        return Database.getQueryLocator(
            'SELECT Id, Completion_Rating__c, Overall_Rating__c, Safety_Incidents__c, Pilot__c FROM Mission__c WHERE Status__c = \'Complete\''
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Mission__c> scope) {
        System.debug('Execute method called');
        List<Contact> contactList = new List<Contact>();
        
        for (Mission__c mission : scope) {
            try {
                System.debug('Processing Mission__c ID: ' + mission.Id);
                
                // Simulate weighted rating calculations
                Double weightedCompletionRate = 0.3 * mission.Completion_Rating__c;
                Double weightedSafetyIncidents = -0.5 * mission.Safety_Incidents__c;
                
                // Intentionally cause an error (Pilot__r.Pilot_Rating__c not queried)
                Double newOverallRating = mission.Pilot__r.Pilot_Rating__c + mission.Overall_Rating__c;
                mission.Pilot__r.Pilot_Rating__c = newOverallRating;
                contactList.add(mission.Pilot__r);
            } catch (Exception e) {
                System.debug('Error processing Mission__c ID: ' + mission.Id);
                System.debug('Error Message: ' + e.getMessage());
                System.debug('Stack Trace: ' + e.getStackTraceString());
                // No manual event publication required for BatchApexErrorEvent
            }
        }

        // Update processed contacts
        if (!contactList.isEmpty()) {
            update contactList;
        }
    }
    
    global void finish(Database.BatchableContext bc) {
        System.debug('Finish method called for Batch Job ID: ' + bc.getJobId());
    }
}