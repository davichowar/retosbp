import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { RescheduleRoutingModule } from './reschedule-routing.module';
import { RescheduleComponent } from './reschedule.component';
import { PrimengModule } from '../primeng/primeng.module';
import { ToolbarModule } from '../toolbar/toolbar.module';


@NgModule({
  declarations: [
    RescheduleComponent
  ],
  imports: [
    CommonModule,
    RescheduleRoutingModule,
    PrimengModule,
    ToolbarModule
  ],
  bootstrap: [RescheduleComponent]
})
export class RescheduleModule { }
