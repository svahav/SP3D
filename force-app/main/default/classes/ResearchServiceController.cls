public with sharing class ResearchServiceController {
    public static Integer processEquipmentsRequest() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Research_Guardian/equipments');
        req.setMethod('GET');
        HttpResponse response = new Http().send(req);

        if (response.getStatusCode() == 200) {
            String responseBody = response.getBody();
            System.debug('Available Equipments: ' + responseBody);
        } else {
            System.debug('Callout failed with status code: ' + response.getStatusCode());
        }

        return response.getStatusCode();
    }
}