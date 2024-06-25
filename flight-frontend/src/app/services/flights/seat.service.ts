import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class SeatService {
  private apiUrl = environment.uriRest;

  private selectedSeatSource = new BehaviorSubject<Seat | null>(null);
  selectedSeat$ = this.selectedSeatSource.asObservable();

  selectSeat(flight: Seat) {
    this.selectedSeatSource.next(flight);
  }

  constructor(private http: HttpClient) { }

  // Obtener los asientos de un vuelo específico
  getSeats(flightId: number): Observable<Seat[]> {
    return this.http.get<Seat[]>(`${this.apiUrl}/flights/${flightId}/seats`);
  }

  // Actualizar el estado de ocupación de un asiento
  updateSeat(seatId: number, isOccupied: boolean, userId: string): Observable<Seat> {
    const url = `${this.apiUrl}/seats/${seatId}`;
    return this.http.put<Seat>(url, { is_occupied: isOccupied, user_id: userId });
  }
}

// Definir la interfaz Seat
export interface Seat {
  seat_id: number;
  flight_id: number;
  seat_number: string;
  is_occupied: boolean;
  created_at: string;
  updated_at: string;
}
