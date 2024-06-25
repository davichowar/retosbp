import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { MainComponent } from './components/main/main.component';
import { AuthGuard } from '@auth0/auth0-angular';

const routes: Routes = [
  {
    path: 'login',
    component: LoginComponent,
  },
  {
    path: 'main',
    component: MainComponent,
    canActivate: [AuthGuard],
  },
  {
    path: '',
    redirectTo: '/main',
    pathMatch: 'full',
  },
  {
    path: 'booking',
    loadChildren: () => import('./modules/booking/booking.module').then(m => m.BookingModule)
  },
  {
    path: 'payments',
    loadChildren: () => import('./modules/payments/payments.module').then(m => m.PaymentsModule)
  },
  { path: 'reschedules', loadChildren: () => import('./modules/reschedules/reschedule.module').then(m => m.RescheduleModule) },
  {
    path: '**',
    redirectTo: '/main',
    pathMatch: 'full',
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
