@RestResource(urlMapping='/lostDevice/*')
global with sharing class LostDeviceService {
    @HttpPost
    global static String reportLostDevice() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        // Parse request body
        String deviceId;
        try {
            Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
            deviceId = (String) requestBody.get('deviceId');
        } catch (Exception e) {
            return 'Invalid request body.';
        }

        if (String.isBlank(deviceId)) {
            return 'Device ID is missing.';
        }

        // Query Asset
        Asset asset = [SELECT Id, Status FROM Asset WHERE Asset_Identifier__c = :deviceId LIMIT 1];
        if (asset == null) {
            return 'Device with ID ' + deviceId + ' not found.';
        }

        // Update Asset Status
        asset.Status = 'Lost';
        update asset;

        return 'Device ' + deviceId + ' has been reported as lost.';
    }

    @HttpGet
    global static String trackInsuranceClaims() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        String deviceId = req.params.get('deviceId');
        if (String.isBlank(deviceId)) {
            return 'Device ID is missing.';
        }

        // Query Asset
        Asset asset = [SELECT Id FROM Asset WHERE Asset_Identifier__c = :deviceId LIMIT 1];
        if (asset == null) {
            return 'Device with ID ' + deviceId + ' not found.';
        }

        // Query Claims
        List<Claim__c> claims = [SELECT Name FROM Claim__c WHERE Asset__c = :asset.Id];
        if (claims.isEmpty()) {
            return 'No insurance claims found for device ' + deviceId + '.';
        }

        String claimsList = '';
        for (Claim__c claim : claims) {
            claimsList += claim.Name + ', ';
        }
        claimsList = claimsList.removeEnd(', ');

        return 'Insurance claims for device ' + deviceId + ': ' + claimsList;
    }
}