export interface Modulo {
    module_id?: number;
    module_name: string;
    icon: string;
    path: string;
    ruta: string;
    desdescription?: string;
}

export interface Flight {
    flight_id: number;
    airline: string;
    flight_number: string;
    departure_airport: string;
    arrival_airport: string;
    departure_city: string;
    arrival_city: string;
    departure_time: Date;
    arrival_time: Date;
    price: number;
    created_at: Date;
    updated_at: Date;
}

export interface Reservation {
    reservation_id: number;
    user_id: number;
    flight_id: number;
    reservation_status: string;
    seat_number: string;
    created_at: Date;
    updated_at: Date;
}

export interface User {
    email?: string;
    email_verified?: boolean;
    family_name?: string;
    given_name?: string;
    name?: string;
    nickname?: string;
    picture?: string;
    sub?: string;
    updated_at?: string;
}

export interface Seat {
    seat_id: number;
    flight_id: number;
    seat_number: string;
    is_occupied: boolean;
    created_at: string;
    updated_at: string;
}