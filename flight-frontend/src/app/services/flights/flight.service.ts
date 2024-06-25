// flight.service.ts

import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';
import { Flight } from 'src/app/models/models';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class FlightService {
  private apiUrl = environment.uriRest + '/flights';

  private selectedFlightSource = new BehaviorSubject<Flight | null>(null);
  selectedFlight$ = this.selectedFlightSource.asObservable();

  selectFlight(flight: Flight) {
    this.selectedFlightSource.next(flight);
  }

  constructor(private http: HttpClient) { }

  // Obtener todos los vuelos
  getFlights(): Observable<Flight[]> {
    return this.http.get<Flight[]>(this.apiUrl);
  }

  // Obtener un vuelo por su ID
  getFlightById(id: number): Observable<Flight> {
    return this.http.get<Flight>(`${this.apiUrl}/${id}`);
  }

  // Crear un nuevo vuelo
  createFlight(flight: Flight): Observable<Flight> {
    return this.http.post<Flight>(this.apiUrl, flight);
  }

  // Actualizar un vuelo existente
  updateFlight(flight: Flight): Observable<Flight> {
    return this.http.put<Flight>(`${this.apiUrl}/${flight.flight_id}`, flight);
  }

  // Eliminar un vuelo
  deleteFlight(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}
