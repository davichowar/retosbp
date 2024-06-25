import { ChangeDetectorRef, Component, ViewChild } from '@angular/core';
import { TabView } from 'primeng/tabview';
import { Flight, Seat } from 'src/app/models/models';
import { FlightService } from 'src/app/services/flights/flight.service';
import { SeatService } from 'src/app/services/flights/seat.service';

@Component({
  selector: 'app-booking',
  templateUrl: './booking.component.html',
  styleUrls: ['./booking.component.scss']
})
export class BookingComponent {
  activeIndex: number = 0;
  selectedFlight: Flight | null = null;
  selectedSeat: Seat | null = null;

  constructor(
    private flightService: FlightService,
    private seatService: SeatService,
  ) { }

  ngOnInit(): void {
    // SUBSCRIBIRSE A LA SELECCION DE VUELO
    this.flightService.selectedFlight$.subscribe(flight => {
      if (flight) {
        this.selectedFlight = flight;
      }
    });

    // SUBSCRIBIRSE A LA SELECCION DE ASIENTO
    this.seatService.selectedSeat$.subscribe(seat => {
      if (seat) {
        this.selectedSeat = seat;
      }
    });
  }
}
