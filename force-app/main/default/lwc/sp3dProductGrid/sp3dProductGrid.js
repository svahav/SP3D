import { LightningElement, api } from 'lwc';
import styles from '@salesforce/resourceUrl/styles';
import { loadStyle } from 'lightning/platformResourceLoader';
export default class Sp3dProductGrid extends LightningElement {
  @api products = [];
  connectedCallback(){ loadStyle(this, styles); }
  add = (e) => { this.dispatchEvent(new CustomEvent('addtocart', { detail:{ product: e.detail.product } })); } 
}
