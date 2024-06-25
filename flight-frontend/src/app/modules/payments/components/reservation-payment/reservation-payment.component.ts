import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { ConfirmationService, MessageService } from 'primeng/api';
import { FormulariosService } from 'src/app/services/admin/formularios.service';
import { PaymentsService } from 'src/app/services/payments/payments.service';

import Swal from 'sweetalert2';

@Component({
  selector: 'app-reservation-payment',
  templateUrl: './reservation-payment.component.html',
  styleUrls: ['./reservation-payment.component.scss'],
  providers: [MessageService, ConfirmationService],
})
export class ReservationPaymentComponent {
  paymentForm: FormGroup;
  paymentMethods = ['PayPal', 'Stripe', 'Tarjeta de Crédito'];

  constructor(
    private fb: FormBuilder,
    private paymentService: PaymentsService,
    public formulariosService: FormulariosService,
    private messageService: MessageService,
    private router: Router,
  ) {
    this.paymentForm = this.fb.group({
      method: ['PayPal', Validators.required],
      cardNumber: [null, Validators.required],
      cardExpiry: ['', Validators.required],
      cardCVC: ['', Validators.required]
    });
  }

  onPay() {
    const paymentData = this.paymentForm.value;

    if (this.paymentForm.controls['method'].value === 'PayPal') {
      this.paymentService.payWithPayPal();
      this.router.navigate(['/main']);
    } else if (this.paymentForm.controls['method'].value === 'Stripe') {
      this.paymentService.payWithStripe();
      this.router.navigate(['/main']);
    } else {
      this.paymentService.payWithCreditCard();
      Swal.fire({
        title: 'Reservas de vuelos',
        text: 'Procesando pago',
        icon: 'info',
        allowOutsideClick: false,
      });
      Swal.showLoading();

      Swal.close();
      this.messageService.add({
        severity: 'success',
        summary: 'Successful',
        detail: 'Pago realizado con éxito',
        life: 3000,
      });
      this.router.navigate(['/main']);
    }
  }

  onMethodChange() {
    if (this.paymentForm.controls['method'].value !== 'Tarjeta de Crédito') {
      this.paymentForm.controls['cardNumber'].disable();
      this.paymentForm.controls['cardExpiry'].disable();
      this.paymentForm.controls['cardCVC'].disable();
    } else {
      this.paymentForm.controls['cardNumber'].enable();
      this.paymentForm.controls['cardExpiry'].enable();
      this.paymentForm.controls['cardCVC'].enable();
    }
  }

  validatePaymentMethod(): boolean {
    if (this.paymentForm.controls['method'].value === 'Tarjeta de Crédito' && this.paymentForm.invalid) {
      return true;
    } else {
      return false;
    }
  }
}
