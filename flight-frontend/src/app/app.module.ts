import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { AppRoutingModule } from './app-routing.module';
import { HTTP_INTERCEPTORS, HttpClientModule } from '@angular/common/http';

import { AppComponent } from './app.component';
import { LoginComponent } from './components/login/login.component';
import { MainComponent } from './components/main/main.component';

import { AuthModule, AuthHttpInterceptor } from '@auth0/auth0-angular';

import { RUTAS } from './secure/rutas';
import { environment as env } from '../environments/environment';
import { ToolbarModule } from './modules/toolbar/toolbar.module';
import { PrimengModule } from './modules/primeng/primeng.module';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    MainComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    HttpClientModule,
    ToolbarModule,
    PrimengModule,
    AuthModule.forRoot({
      ...env.auth,
      httpInterceptor: {
        allowedList: [...RUTAS],
      },
      authorizationParams: {
        redirect_uri: window.location.origin
      },
    }),
  ],
  providers: [
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthHttpInterceptor,
      multi: true,
    },
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
