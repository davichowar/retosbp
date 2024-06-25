import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { BookingRoutingModule } from './booking-routing.module';
import { BookingComponent } from './booking.component';
import { PrimengModule } from '../primeng/primeng.module';
import { FullCalendarModule } from '@fullcalendar/angular';
import { ToolbarModule } from '../toolbar/toolbar.module';
import { FlightReservationComponent } from './components/flight-reservation/flight-reservation.component';
import { FlightsSearchComponent } from './components/flights-search/flights-search.component';
import { SeatMapComponent } from './components/seat-map/seat-map.component';
import { PaymentsModule } from '../payments/payments.module';


@NgModule({
  declarations: [
    BookingComponent,
    FlightReservationComponent,
    FlightsSearchComponent,
    SeatMapComponent,
  ],
  imports: [
    CommonModule,
    BookingRoutingModule,
    PrimengModule,
    ToolbarModule,
    FullCalendarModule,
    PaymentsModule,
  ]
})
export class BookingModule { }
