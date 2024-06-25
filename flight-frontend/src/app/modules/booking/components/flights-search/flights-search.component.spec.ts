import { ComponentFixture, TestBed } from '@angular/core/testing';

import { FlightsSearchComponent } from './flights-search.component';

describe('FlightsSearchComponent', () => {
  let component: FlightsSearchComponent;
  let fixture: ComponentFixture<FlightsSearchComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [FlightsSearchComponent]
    });
    fixture = TestBed.createComponent(FlightsSearchComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
