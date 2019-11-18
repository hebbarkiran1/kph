import { LightningElement } from 'lwc';

export default class LwcDemoComponent1 extends LightningElement {
    publicGreeting = 'Anirudh';

    handleChange(event) {
        this.publicGreeting = event.target.value;
    }

}