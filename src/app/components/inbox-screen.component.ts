import { Component } from '@angular/core';
import { Store } from '@ngxs/store';
import { stat } from 'fs';
import { Observable } from 'rxjs';

@Component({
  selector: 'app-inbox-screen',
  templateUrl: './inbox-screen.component.html',
})
export class InboxScreenComponent {
  error$: Observable<boolean>;
  constructor(private store: Store) {
    this.error$ = store.select((state) => state.taskbox.error);
  }
}
