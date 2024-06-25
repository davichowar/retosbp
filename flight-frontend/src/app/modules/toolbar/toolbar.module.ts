import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ToolbarComponent } from './toolbar/toolbar.component';
import { PrimengModule } from '../primeng/primeng.module';

@NgModule({
  declarations: [
    ToolbarComponent
  ],
  imports: [
    CommonModule,
    PrimengModule,
  ],
  exports: [ToolbarComponent]
})
export class ToolbarModule { }
