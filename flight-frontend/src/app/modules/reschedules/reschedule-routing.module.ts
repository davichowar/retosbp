import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { RescheduleComponent } from './reschedule.component';

const routes: Routes = [{ path: '', component: RescheduleComponent }];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class RescheduleRoutingModule { }
