import { LightningElement, api } from 'lwc';
import styles from '@salesforce/resourceUrl/styles';
import { loadStyle } from 'lightning/platformResourceLoader';
export default class Sp3dProductCard extends LightningElement {
  @api product;
  connectedCallback(){ loadStyle(this, styles); }
  get price(){ return (this.product?.price ?? 0).toFixed(0); }
  add(){ this.dispatchEvent(new CustomEvent('add', { detail:{ product: this.product } })); }
  details(){ /* אופציונלי: פתיחת מודל תיאור */ }
}
