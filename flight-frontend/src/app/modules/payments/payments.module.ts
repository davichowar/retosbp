import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { PaymentsRoutingModule } from './payments-routing.module';
import { PaymentsComponent } from './payments.component';
import { ReservationPaymentComponent } from './components/reservation-payment/reservation-payment.component';
import { PrimengModule } from '../primeng/primeng.module';
import { ToolbarModule } from '../toolbar/toolbar.module';


@NgModule({
  declarations: [
    PaymentsComponent,
    ReservationPaymentComponent
  ],
  imports: [
    CommonModule,
    PaymentsRoutingModule,
    PrimengModule,
    ToolbarModule,
  ],
  exports: [
    ReservationPaymentComponent,
  ]
})
export class PaymentsModule { }
