import { LightningElement, api } from 'lwc';
import styles from '@salesforce/resourceUrl/styles';
import { loadStyle } from 'lightning/platformResourceLoader';

export default class Sp3dHeader extends LightningElement {
  @api cartCount = 0;
  connectedCallback(){ loadStyle(this, styles); }
  get has(){ return this.cartCount > 0; }
  onInput(e){ this.dispatchEvent(new CustomEvent('searchchange', { detail:{ value: e.target.value } })); }
  cartClick(){ this.dispatchEvent(new CustomEvent('cartclick')); }
}
