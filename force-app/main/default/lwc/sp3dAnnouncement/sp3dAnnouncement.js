import { LightningElement } from 'lwc';
import styles from '@salesforce/resourceUrl/styles';
import { loadStyle } from 'lightning/platformResourceLoader';
export default class Sp3dAnnouncement extends LightningElement { connectedCallback(){ loadStyle(this, styles); } }
