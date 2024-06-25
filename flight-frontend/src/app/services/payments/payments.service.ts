import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { MessageService } from 'primeng/api';
import { Observable } from 'rxjs';
import { environment } from 'src/environments/environment';

import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root'
})
export class PaymentsService {
  private apiUrl = environment.uriRest;
  private stripeUrl = environment.uriStripe;
  private payPalUrl = environment.uriPayPal;

  constructor(private http: HttpClient) { }

  payWithPayPal() {
    Swal.fire({
      title: 'Reservas de vuelos',
      text: 'Redirigiendo a PayPal',
      icon: 'info',
      allowOutsideClick: false,
    });
    Swal.showLoading();

    setTimeout(function () {
      Swal.close();
      window.open('https://www.paypal.com/', '_blank');
    }, 3000);
  }

  payWithStripe() {
    Swal.fire({
      title: 'Reservas de vuelos',
      text: 'Redirigiendo a PayPal',
      icon: 'info',
      allowOutsideClick: false,
    });
    Swal.showLoading();

    setTimeout(function () {
      Swal.close();
      window.open('https://stripe.com/', '_blank');
    }, 3000);
  }

  payWithCreditCard() {
    // return this.http.post(this.apiUrl + '/credit', data);
  }
}
