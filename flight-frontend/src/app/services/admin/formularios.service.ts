import { Injectable } from '@angular/core';
import { AbstractControl } from '@angular/forms';

@Injectable({
  providedIn: 'root'
})
export class FormulariosService {

  constructor() { }

  public getErrors(control: AbstractControl, controlName: string): string[] {
    const errors: string[] = [];

    if (control.touched && control.invalid != null) {
      for (const auxError in control.errors) {
        if (control.errors[auxError]) {
          switch (auxError) {
            case 'required': {
              errors.push(controlName + ' es mandatorio');
              break;
            }
            case 'matDatepickerParse': {
              errors.push(' Formato de fecha no válido');
              break;
            }
            case 'pattern': {
              if (controlName.toLowerCase().indexOf('mail') > 0) {
                errors.push(' Ingrese un email válido');
              } else if (controlName.toLowerCase().indexOf('celular') > 0) {
                errors.push(' Ingrese un teléfono celular válido');
              } else {
                errors.push(' Error de formato establecido');
              }
              break;
            }
            case 'email': {
              errors.push(' Ingrese un correo electrónico válido');
              break;
            }
            case 'matDatepickerMax': {
              errors.push(' Fecha expedición no puede ser mayor a fecha actual');
              break;
            }
            case 'minlength': {
              errors.push(' longitud mínima no válida');
              break;
            }
            case 'maxlength': {
              errors.push(' longitud máxima no válida');
              break;
            }
            /* default: {
              errors.push(controlName + ' Error');
              break;
            } */
          }
        }
      }
    }
    return errors;
  }
}
