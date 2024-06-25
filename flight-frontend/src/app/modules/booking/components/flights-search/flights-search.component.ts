import { Component, EventEmitter, Output } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ConfirmationService, MessageService } from 'primeng/api';
import { Flight } from 'src/app/models/models';
import { FormulariosService } from 'src/app/services/admin/formularios.service';
import { FlightService } from 'src/app/services/flights/flight.service';

import Swal from 'sweetalert2';

@Component({
  selector: 'app-flights-search',
  templateUrl: './flights-search.component.html',
  styleUrls: ['./flights-search.component.scss'],
  providers: [MessageService, ConfirmationService],
})
export class FlightsSearchComponent {
  searchForm: FormGroup;

  departureCities: string[] = [];
  arrivalCities: string[] = [];
  airports: string[] = [];
  flights: Flight[] = [];
  filteredFlights: Flight[] = [];
  selectedFlight: Flight;

  minDate = new Date();

  constructor(private formBuilder: FormBuilder,
    private flightService: FlightService,
    public formulariosService: FormulariosService,
    private messageService: MessageService,
    private confirmationService: ConfirmationService,) {

    this.searchForm = this.formBuilder.group({
      departure_city: ['', Validators.required],
      arrival_city: ['', Validators.required],
    });
  }

  ngOnInit(): void {
    this.loadFlights();
  }

  loadFlights(): void {
    Swal.fire({
      title: 'Reservas de vuelos',
      text: 'Cargando vuelos',
      icon: 'info',
      allowOutsideClick: false,
    });
    Swal.showLoading();

    this.flightService.getFlights().subscribe(
      flights => {
        Swal.close();
        this.flights = flights;

        this.arrivalCities = Array.from(new Set(flights.map(flight => flight.arrival_city)));
        this.departureCities = Array.from(new Set(flights.map(flight => flight.departure_city)));
      },
      error => {
        console.log('Error fetching flights:', error);
      }
    );
  }

  filterFlights(
    flights: Flight[],
    filters: {
      departureCity?: string;
      arrivalCity?: string;
    }
  ): Flight[] {
    return flights.filter(flight => {
      const matchesDepartureCity = filters.departureCity ? flight.departure_city === filters.departureCity : true;
      const matchesArrivalCity = filters.arrivalCity ? flight.arrival_city === filters.arrivalCity : true;

      return matchesDepartureCity && matchesArrivalCity;
    });
  }

  searchFlights() {
    const filters = {
      departureCity: this.searchForm.get('departure_city').value,
      arrivalCity: this.searchForm.get('arrival_city').value,
    };

    this.filteredFlights = this.filterFlights(this.flights, filters);

    if (this.filteredFlights.length > 0) {
      this.messageService.add({
        severity: 'success',
        summary: 'Successful',
        detail: 'Vuelos encontrados',
        life: 3000,
      });
    } else {
      this.messageService.add({
        severity: 'warn',
        summary: 'Advertencia',
        detail: 'No se encontraron vuelos',
        life: 3000,
      });
    }
  }

  selectFlight(flight: Flight) {
    this.selectedFlight = flight;
    this.flightService.selectFlight(flight);

    this.messageService.add({
      severity: 'success',
      summary: 'Successful',
      detail: 'Vuelo seleccionado',
      life: 3000,
    });
  }
}
