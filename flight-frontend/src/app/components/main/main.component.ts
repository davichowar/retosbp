import { ChangeDetectorRef, Component } from '@angular/core';
import { Router } from '@angular/router';
import { Modulo } from 'src/app/models/models';
import { LocalService } from 'src/app/services/secure/local.service';
import { UsersService } from 'src/app/services/users/users.service';

@Component({
  selector: 'app-main',
  templateUrl: './main.component.html',
  styleUrls: ['./main.component.scss']
})
export class MainComponent {
  public modulos: Modulo[] = [];

  constructor(
    public userService: UsersService,
    private secureStorage: LocalService,
    private changeDetectorRef: ChangeDetectorRef,
    private router: Router
  ) { }

  ngAfterViewInit() {
    // OBSERVABLE PARA OBTENER MÓDULOS
    this.userService.currentModulos.subscribe((data) => {
      if (data) {
        this.modulos = data;
        this.secureStorage.setJsonValue('modulos', data);
        this.changeDetectorRef.detectChanges();
      }
    });

    // this.modulos = this.secureStorage.getJsonValue( 'modulos' );
    this.changeDetectorRef.detectChanges();
  }

  public cargarModulo(modulo: Modulo): void {
    this.secureStorage.setJsonValue('modulo', modulo.module_id);
    this.router.navigateByUrl('/' + modulo.path);
  }
}
