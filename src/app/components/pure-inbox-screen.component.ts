import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-pure-inbox-screen',
  templateUrl: './pure-inbox-screen.component.html',
})
export class PureInboxScreenComponent {
  @Input() error: any;
}
