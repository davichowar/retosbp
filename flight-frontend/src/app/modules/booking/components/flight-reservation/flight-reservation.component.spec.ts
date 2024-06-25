import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FlightReservationComponent } from './flight-reservation.component';

describe('FlightReservationComponent', () => {
  let component: FlightReservationComponent;
  let fixture: ComponentFixture<FlightReservationComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [FlightReservationComponent]
    });
    fixture = TestBed.createComponent(FlightReservationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
