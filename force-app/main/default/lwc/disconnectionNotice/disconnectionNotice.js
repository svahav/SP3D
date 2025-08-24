import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError } from 'lightning/empApi';

export default class DisconnectionNotice extends LightningElement {
    channelName = '/event/Asset_Disconnection__e'; // Platform event channel
    isSubscribeDisabled = false; // Control subscribe button state
    isUnsubscribeDisabled = true; // Control unsubscribe button state
    subscription = {}; // Store subscription details

    // Tracks changes to the channel name input field
    handleChannelName(event) {
        this.channelName = event.target.value;
    }
    connectedCallback() {
        this.handleSubscribe();
    }

    // Subscribe to the platform event
    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        const messageCallback = (response) => {
            console.log('New message received: ', JSON.stringify(response));

            // Extract payload from the response
            const payload = response.data.payload;

            // Check the Disconnected__c status in the payload and display toast
            if (payload.Disconnected__c) {
                this.showSuccessToast(payload.Asset_Identifier__c);
            } else {
                this.showErrorToast(payload.Asset_Identifier__c);
            }
        };

        // Subscribe to the platform event channel
        subscribe(this.channelName, -1, messageCallback).then((response) => {
            console.log('Subscription successful: ', JSON.stringify(response));
            this.subscription = response; // Save subscription details
            this.toggleSubscribeButton(true);
        });
    }

    // Unsubscribe from the platform event
    handleUnsubscribe() {
        unsubscribe(this.subscription, (response) => {
            console.log('Unsubscribed successfully: ', JSON.stringify(response));
            this.toggleSubscribeButton(false);
        }).catch((error) => {
            console.error('Error unsubscribing: ', error);
        });
    }

    // Enable or disable the subscribe/unsubscribe buttons
    toggleSubscribeButton(enableSubscribe) {
        this.isSubscribeDisabled = enableSubscribe;
        this.isUnsubscribeDisabled = !enableSubscribe;
    }

    // Show success toast
    showSuccessToast(assetId) {
        const event = new ShowToastEvent({
            title: 'Success',
            message: `Asset Id ${assetId} is now disconnected.`,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    // Show error toast
    showErrorToast(assetId) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: `Asset Id ${assetId} was not disconnected. Try again.`,
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    // Register error listener for empApi errors
    connectedCallback() {
        onError((error) => {
            console.error('Received error from server: ', JSON.stringify(error));
        });
    }
}