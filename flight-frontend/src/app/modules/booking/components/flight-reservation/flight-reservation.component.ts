import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ConfirmationService, MessageService } from 'primeng/api';
import { Flight, Reservation } from 'src/app/models/models';
import { FormulariosService } from 'src/app/services/admin/formularios.service';
import { FlightService } from 'src/app/services/flights/flight.service';
import { ReservationService } from 'src/app/services/reservations/reservation.service';

@Component({
  selector: 'app-flight-reservation',
  templateUrl: './flight-reservation.component.html',
  styleUrls: ['./flight-reservation.component.scss'],
  providers: [MessageService, ConfirmationService],
})
export class FlightReservationComponent {
  reservationForm: FormGroup;

  selectedFlight: Flight | null = null;

  constructor(
    private formBuilder: FormBuilder,
    private reservationService: ReservationService,
    private flightService: FlightService,
    private router: Router,
    public formulariosService: FormulariosService,
    private messageService: MessageService,
    private confirmationService: ConfirmationService,
  ) {
    this.reservationForm = this.formBuilder.group({
      user_id: ['', Validators.required],
      flight_id: ['', Validators.required],
      reservation_status: ['pending'],
      seat_number: ['', Validators.required]
    });
  }

  ngOnInit(): void {
    this.flightService.selectedFlight$.subscribe(flight => {
      if (flight) {
        this.selectedFlight = flight;
        console.log(this.selectedFlight);
      }
    });
  }

  onSubmit(): void {
    if (this.reservationForm.valid) {
      const reservation: Reservation = this.reservationForm.value;
      reservation.created_at = new Date();
      reservation.updated_at = new Date();

      console.log(reservation);

      this.reservationService.createReservation(reservation).subscribe(
        () => {
          console.log('Reserva creada exitosamente');
          this.router.navigate(['/reservations']); // Redirigir a la lista de reservas o a donde necesites
        },
        error => {
          console.error('Error al crear reserva:', error);
        }
      );
    } else {
      console.error('Formulario inválido');
    }
  }
}
