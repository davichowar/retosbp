import { Component } from '@angular/core';
import { AuthService } from '@auth0/auth0-angular';
import { User } from 'src/app/models/models';
import { LocalService } from 'src/app/services/secure/local.service';
import { UsersService } from 'src/app/services/users/users.service';

import Swal from 'sweetalert2';

@Component({
  selector: 'app-toolbar',
  templateUrl: './toolbar.component.html',
  styleUrls: ['./toolbar.component.scss']
})
export class ToolbarComponent {
  public usuario: User;

  constructor(
    public userService: UsersService,
    private secureStorage: LocalService,
  ) { }

  ngOnInit(): void {
    this.usuario = this.secureStorage.getJsonValue('usuario');
  }
}
