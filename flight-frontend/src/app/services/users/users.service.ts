import { Injectable } from '@angular/core';
import { AuthService } from '@auth0/auth0-angular';

import Swal from 'sweetalert2';
import { LocalService } from '../secure/local.service';
import { Modulo, User } from 'src/app/models/models';
import { BehaviorSubject } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class UsersService {
  private uri: string = environment.uriRest;

  private modulos: Modulo[] = [];

  private modulosSource = new BehaviorSubject(this.modulos);

  public currentModulos = this.modulosSource.asObservable();

  private setModulos(modulosPerfil: Modulo[]) {
    this.modulosSource.next(modulosPerfil);
  }

  constructor(public auth: AuthService, private secureStorage: LocalService, private http: HttpClient,) {
    this.auth.user$.subscribe((auth0Data) => {
      if (auth0Data) {
        Swal.fire({
          text: 'Obteniendo información de usuario',
          allowOutsideClick: false,
        });
        Swal.showLoading();

        const usuario: User = auth0Data;

        this.secureStorage.setJsonValue('usuario', usuario);

        this.http
          .get<any>(this.uri + '/module')
          .subscribe(
            (data: any) => {
              Swal.close();

              if (data.codigo === 200) {
                if (data.modulos.length > 0) {
                  this.setModulos(data.modulos);
                } else {
                  Swal.fire({
                    title: 'ERROR',
                    text:
                      'No existen módulos definidos',
                    allowOutsideClick: false,
                    icon: 'error',
                    didClose: () => {
                      this.logout();
                    },
                  });
                }
              } else {
                console.error(
                  'Error al obtener información del usuario: ' + data.error
                );
                Swal.fire({
                  title: 'Reservas de vuelos',
                  text:
                    'Error del sistema al obtener información del usuario: ' +
                    data.error,
                  icon: 'error',
                  allowOutsideClick: false,
                  didClose: () => {
                    this.logout();
                  },
                });
              }
            },
            (error: any) => {
              Swal.close();
              console.error(
                'Error al obtener información del usuario: ' +
                '<<<' +
                JSON.stringify(error) +
                '>>>'
              );
              Swal.fire({
                title: 'Reservas de vuelos',
                text:
                  'Error del sistema al obtener información del usuario: ' +
                  JSON.stringify(error),
                icon: 'error',
                allowOutsideClick: false,
                didClose: () => {
                  this.logout();
                },
              });
            }
          );

        Swal.close();
      }
    });
  }

  // AUTH0
  public logout(): void {
    this.auth.logout({ logoutParams: { returnTo: document.location.origin } });
  }
}
