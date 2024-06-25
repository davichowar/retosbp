import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { BookingComponent } from './booking.component';
import { AuthGuard } from '@auth0/auth0-angular';
import { FlightReservationComponent } from './components/flight-reservation/flight-reservation.component';

const routes: Routes = [
  {
    path: '', component: BookingComponent,
    children: [
      {
        path: 'flight-reservation',
        component: FlightReservationComponent,
        canActivate: [AuthGuard],
      },
    ],
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class BookingRoutingModule { }
