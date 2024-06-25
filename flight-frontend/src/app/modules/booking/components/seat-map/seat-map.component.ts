// seat-map.component.ts
import { Component, OnInit } from '@angular/core';
import { ConfirmationService, MessageService } from 'primeng/api';
import { Flight, Seat, User } from 'src/app/models/models';
import { FlightService } from 'src/app/services/flights/flight.service';
import { SeatService } from 'src/app/services/flights/seat.service';
import { LocalService } from 'src/app/services/secure/local.service';

import Swal from 'sweetalert2';

@Component({
  selector: 'app-seat-map',
  templateUrl: './seat-map.component.html',
  styleUrls: ['./seat-map.component.scss'],
  providers: [MessageService, ConfirmationService],
})
export class SeatMapComponent implements OnInit {
  selectedFlight: Flight | null = null;
  seats: Seat[] = [];
  selectedSeat: Seat | null = null;
  seatConfirmed = false;

  usuario: User;

  constructor(
    private seatService: SeatService,
    private flightService: FlightService,
    private confirmationService: ConfirmationService,
    private secureStorage: LocalService,
    private messageService: MessageService,
  ) { }

  ngOnInit() {
    this.usuario = this.secureStorage.getJsonValue('usuario');

    this.flightService.selectedFlight$.subscribe(flight => {
      if (flight) {
        this.selectedFlight = flight;

        this.getSeats();
      }
    });
  }

  getSeats() {
    Swal.fire({
      title: 'Reservas de vuelos',
      text: 'Obteniendo asientos',
      icon: 'info',
      allowOutsideClick: false,
    });
    Swal.showLoading();

    this.seatService.getSeats(this.selectedFlight.flight_id).subscribe(
      data => {
        Swal.close();
        this.seats = data;
      },
      error => {
        console.error('Error fetching seats', error);
      }
    );
  }

  selectSeat(seat: Seat) {
    if (!seat.is_occupied) {
      this.selectedSeat = seat;
    }
  }

  confirmSeatOccupation(seat: Seat) {
    Swal.fire({
      title: 'Reservas de vuelos',
      text: 'Guardando selección',
      icon: 'info',
      allowOutsideClick: false,
    });
    Swal.showLoading();

    const newStatus = !seat.is_occupied;
    this.confirmationService.confirm({
      message: 'Está seguro de seleccionar el asiento ' + seat.seat_number + '?',
      header: 'Confirmar',
      icon: 'pi pi-exclamation-triangle',
      acceptLabel: 'Si',
      rejectLabel: 'No',
      accept: () => {
        this.seatService.updateSeat(seat.seat_id, newStatus, this.usuario.sub).subscribe(
          updatedSeat => {
            Swal.close();
            seat.is_occupied = updatedSeat.is_occupied;
            this.seatService.selectSeat(seat);
            this.seatConfirmed = true;

            this.messageService.add({
              severity: 'success',
              summary: 'Successful',
              detail: 'Asiento reservado',
              life: 3000,
            });
          },
          error => {
            console.error('Error updating seat', error);
            this.messageService.add({
              severity: 'error',
              summary: 'Error',
              detail: JSON.stringify(error),
              life: 3000,
            });
          }
        );
      },
    });
  }

  getSeatRows(): Seat[][] {
    const numRows = Math.ceil(this.seats.length / 3); // Ajustar el número de asientos por fila según sea necesario
    const rows: Seat[][] = [];

    for (let i = 0; i < numRows; i++) {
      rows.push(this.seats.slice(i * 3, i * 3 + 3));
    }

    return rows;
  }

  isSelected(seat: Seat): boolean {
    return this.selectedSeat === seat;
  }
}
