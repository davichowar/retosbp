--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Debian 16.3-1.pgdg120+1)
-- Dumped by pg_dump version 16.3

-- Started on 2024-06-25 09:52:14

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "flight-db";
--
-- TOC entry 3508 (class 1262 OID 16384)
-- Name: flight-db; Type: DATABASE; Schema: -; Owner: flight
--

CREATE DATABASE "flight-db" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE "flight-db" OWNER TO flight;

\connect -reuse-previous=on "dbname='flight-db'"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 234 (class 1259 OID 16540)
-- Name: catalog_items; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.catalog_items (
    item_id integer NOT NULL,
    catalog_id integer,
    item_name character varying(50) NOT NULL,
    item_description text,
    item_price numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.catalog_items OWNER TO flight;

--
-- TOC entry 233 (class 1259 OID 16539)
-- Name: catalog_items_item_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.catalog_items_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.catalog_items_item_id_seq OWNER TO flight;

--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 233
-- Name: catalog_items_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.catalog_items_item_id_seq OWNED BY public.catalog_items.item_id;


--
-- TOC entry 232 (class 1259 OID 16527)
-- Name: catalogs; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.catalogs (
    catalog_id integer NOT NULL,
    catalog_name character varying(50) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.catalogs OWNER TO flight;

--
-- TOC entry 231 (class 1259 OID 16526)
-- Name: catalogs_catalog_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.catalogs_catalog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.catalogs_catalog_id_seq OWNER TO flight;

--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 231
-- Name: catalogs_catalog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.catalogs_catalog_id_seq OWNED BY public.catalogs.catalog_id;


--
-- TOC entry 224 (class 1259 OID 16466)
-- Name: flights; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.flights (
    flight_id integer NOT NULL,
    airline character varying(50) NOT NULL,
    flight_number character varying(20) NOT NULL,
    departure_airport character varying(3) NOT NULL,
    arrival_airport character varying(3) NOT NULL,
    departure_time timestamp without time zone NOT NULL,
    arrival_time timestamp without time zone NOT NULL,
    price numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    departure_city character varying,
    arrival_city character varying
);


ALTER TABLE public.flights OWNER TO flight;

--
-- TOC entry 223 (class 1259 OID 16465)
-- Name: flights_flight_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.flights_flight_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.flights_flight_id_seq OWNER TO flight;

--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 223
-- Name: flights_flight_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.flights_flight_id_seq OWNED BY public.flights.flight_id;


--
-- TOC entry 221 (class 1259 OID 16435)
-- Name: modules; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.modules (
    module_id integer NOT NULL,
    module_name character varying(50) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    icon character varying NOT NULL,
    path character varying NOT NULL
);


ALTER TABLE public.modules OWNER TO flight;

--
-- TOC entry 220 (class 1259 OID 16434)
-- Name: modules_module_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.modules_module_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.modules_module_id_seq OWNER TO flight;

--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 220
-- Name: modules_module_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.modules_module_id_seq OWNED BY public.modules.module_id;


--
-- TOC entry 230 (class 1259 OID 16510)
-- Name: notifications; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.notifications (
    notification_id integer NOT NULL,
    user_id integer,
    message text NOT NULL,
    is_sent boolean DEFAULT false,
    send_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO flight;

--
-- TOC entry 229 (class 1259 OID 16509)
-- Name: notifications_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.notifications_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_notification_id_seq OWNER TO flight;

--
-- TOC entry 3514 (class 0 OID 0)
-- Dependencies: 229
-- Name: notifications_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.notifications_notification_id_seq OWNED BY public.notifications.notification_id;


--
-- TOC entry 228 (class 1259 OID 16495)
-- Name: payments; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    reservation_id integer,
    payment_status character varying(20) DEFAULT 'pending'::character varying,
    amount numeric(10,2) NOT NULL,
    payment_method character varying(50) NOT NULL,
    transaction_id character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.payments OWNER TO flight;

--
-- TOC entry 227 (class 1259 OID 16494)
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO flight;

--
-- TOC entry 3515 (class 0 OID 0)
-- Dependencies: 227
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- TOC entry 218 (class 1259 OID 16406)
-- Name: profiles; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.profiles (
    profile_id integer NOT NULL,
    profile_name character varying(50) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.profiles OWNER TO flight;

--
-- TOC entry 217 (class 1259 OID 16405)
-- Name: profiles_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.profiles_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profiles_profile_id_seq OWNER TO flight;

--
-- TOC entry 3516 (class 0 OID 0)
-- Dependencies: 217
-- Name: profiles_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.profiles_profile_id_seq OWNED BY public.profiles.profile_id;


--
-- TOC entry 226 (class 1259 OID 16475)
-- Name: reservations; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.reservations (
    reservation_id integer NOT NULL,
    user_id character varying(50),
    flight_id integer NOT NULL,
    reservation_status character varying(20) DEFAULT 'booked'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    seat_id integer NOT NULL
);


ALTER TABLE public.reservations OWNER TO flight;

--
-- TOC entry 225 (class 1259 OID 16474)
-- Name: reservations_reservation_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.reservations_reservation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reservations_reservation_id_seq OWNER TO flight;

--
-- TOC entry 3517 (class 0 OID 0)
-- Dependencies: 225
-- Name: reservations_reservation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.reservations_reservation_id_seq OWNED BY public.reservations.reservation_id;


--
-- TOC entry 236 (class 1259 OID 16573)
-- Name: seats; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.seats (
    seat_id integer NOT NULL,
    flight_id integer NOT NULL,
    seat_number character varying(5) NOT NULL,
    is_occupied boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_id character varying(50)
);


ALTER TABLE public.seats OWNER TO flight;

--
-- TOC entry 235 (class 1259 OID 16572)
-- Name: seats_seat_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.seats_seat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seats_seat_id_seq OWNER TO flight;

--
-- TOC entry 3518 (class 0 OID 0)
-- Dependencies: 235
-- Name: seats_seat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.seats_seat_id_seq OWNED BY public.seats.seat_id;


--
-- TOC entry 222 (class 1259 OID 16447)
-- Name: user_modules; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.user_modules (
    user_id integer NOT NULL,
    module_id integer NOT NULL,
    access_level character varying(20) DEFAULT 'read'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_modules OWNER TO flight;

--
-- TOC entry 219 (class 1259 OID 16418)
-- Name: user_profiles; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.user_profiles (
    user_id integer NOT NULL,
    profile_id integer NOT NULL,
    assigned_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.user_profiles OWNER TO flight;

--
-- TOC entry 216 (class 1259 OID 16391)
-- Name: users; Type: TABLE; Schema: public; Owner: flight
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(100) NOT NULL,
    first_name character varying(50),
    last_name character varying(50),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO flight;

--
-- TOC entry 215 (class 1259 OID 16390)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: flight
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO flight;

--
-- TOC entry 3519 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: flight
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 3287 (class 2604 OID 16543)
-- Name: catalog_items item_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.catalog_items ALTER COLUMN item_id SET DEFAULT nextval('public.catalog_items_item_id_seq'::regclass);


--
-- TOC entry 3284 (class 2604 OID 16530)
-- Name: catalogs catalog_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.catalogs ALTER COLUMN catalog_id SET DEFAULT nextval('public.catalogs_catalog_id_seq'::regclass);


--
-- TOC entry 3269 (class 2604 OID 16469)
-- Name: flights flight_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.flights ALTER COLUMN flight_id SET DEFAULT nextval('public.flights_flight_id_seq'::regclass);


--
-- TOC entry 3263 (class 2604 OID 16438)
-- Name: modules module_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.modules ALTER COLUMN module_id SET DEFAULT nextval('public.modules_module_id_seq'::regclass);


--
-- TOC entry 3280 (class 2604 OID 16513)
-- Name: notifications notification_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.notifications ALTER COLUMN notification_id SET DEFAULT nextval('public.notifications_notification_id_seq'::regclass);


--
-- TOC entry 3276 (class 2604 OID 16498)
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- TOC entry 3259 (class 2604 OID 16409)
-- Name: profiles profile_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.profiles ALTER COLUMN profile_id SET DEFAULT nextval('public.profiles_profile_id_seq'::regclass);


--
-- TOC entry 3272 (class 2604 OID 16478)
-- Name: reservations reservation_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.reservations ALTER COLUMN reservation_id SET DEFAULT nextval('public.reservations_reservation_id_seq'::regclass);


--
-- TOC entry 3290 (class 2604 OID 16576)
-- Name: seats seat_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.seats ALTER COLUMN seat_id SET DEFAULT nextval('public.seats_seat_id_seq'::regclass);


--
-- TOC entry 3256 (class 2604 OID 16394)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 3500 (class 0 OID 16540)
-- Dependencies: 234
-- Data for Name: catalog_items; Type: TABLE DATA; Schema: public; Owner: flight
--



--
-- TOC entry 3498 (class 0 OID 16527)
-- Dependencies: 232
-- Data for Name: catalogs; Type: TABLE DATA; Schema: public; Owner: flight
--



--
-- TOC entry 3490 (class 0 OID 16466)
-- Dependencies: 224
-- Data for Name: flights; Type: TABLE DATA; Schema: public; Owner: flight
--

INSERT INTO public.flights VALUES (1, 'American Airlines', 'AA123', 'JFK', 'LAX', '2024-07-01 08:00:00', '2024-07-01 12:00:00', 350.00, '2024-06-23 13:08:22.137609', '2024-06-23 13:08:22.137609', 'Nueva York', 'Los Ángeles');
INSERT INTO public.flights VALUES (2, 'Delta Airlines', 'DL456', 'ATL', 'ORD', '2024-07-05 10:30:00', '2024-07-05 12:30:00', 250.00, '2024-06-23 13:08:22.137609', '2024-06-23 13:08:22.137609', 'Atlanta', 'Chicago');
INSERT INTO public.flights VALUES (3, 'United Airlines', 'UA789', 'SFO', 'SEA', '2024-07-10 15:00:00', '2024-07-10 17:00:00', 180.50, '2024-06-23 13:08:22.137609', '2024-06-23 13:08:22.137609', 'San Francisco', 'Seattle');
INSERT INTO public.flights VALUES (4, 'British Airways', 'BA456', 'LHR', 'CDG', '2024-07-15 09:15:00', '2024-07-15 12:30:00', 420.00, '2024-06-23 13:09:22.043232', '2024-06-23 13:09:22.043232', 'Londres', 'París');
INSERT INTO public.flights VALUES (5, 'Lufthansa', 'LH789', 'FRA', 'JFK', '2024-07-20 14:00:00', '2024-07-20 19:30:00', 580.50, '2024-06-23 13:09:22.043232', '2024-06-23 13:09:22.043232', 'Alemania', 'Nueva York');
INSERT INTO public.flights VALUES (6, 'Emirates', 'EK123', 'DXB', 'SFO', '2024-07-25 11:45:00', '2024-07-25 16:00:00', 950.00, '2024-06-23 13:09:22.043232', '2024-06-23 13:09:22.043232', 'Dubái', 'San Francisco');
INSERT INTO public.flights VALUES (7, 'Qatar Airways', 'QR456', 'DOH', 'SYD', '2024-08-01 19:30:00', '2024-08-02 07:00:00', 720.00, '2024-06-23 13:09:22.043232', '2024-06-23 13:09:22.043232', 'Doha', 'Sídney');
INSERT INTO public.flights VALUES (8, 'Singapore Airlines', 'SQ789', 'SIN', 'LAX', '2024-08-10 22:00:00', '2024-08-11 04:30:00', 850.00, '2024-06-23 13:09:22.043232', '2024-06-23 13:09:22.043232', 'Singapur', 'Los Ángeles');


--
-- TOC entry 3487 (class 0 OID 16435)
-- Dependencies: 221
-- Data for Name: modules; Type: TABLE DATA; Schema: public; Owner: flight
--

INSERT INTO public.modules VALUES (4, 'Reagendamiento', NULL, '2024-06-23 12:19:24.453294', '2024-06-23 12:19:24.453294', 'reschedule', 'reschedules');
INSERT INTO public.modules VALUES (2, 'Reservas', NULL, '2024-06-23 11:57:13.217032', '2024-06-23 11:57:13.217032', 'booking', 'booking');


--
-- TOC entry 3496 (class 0 OID 16510)
-- Dependencies: 230
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: flight
--



--
-- TOC entry 3494 (class 0 OID 16495)
-- Dependencies: 228
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: flight
--



--
-- TOC entry 3484 (class 0 OID 16406)
-- Dependencies: 218
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: flight
--



--
-- TOC entry 3492 (class 0 OID 16475)
-- Dependencies: 226
-- Data for Name: reservations; Type: TABLE DATA; Schema: public; Owner: flight
--

INSERT INTO public.reservations VALUES (4, '1', 1, 'paid', '2024-06-23 18:59:39.748129', '2024-06-23 18:59:39.748135', 1);


--
-- TOC entry 3502 (class 0 OID 16573)
-- Dependencies: 236
-- Data for Name: seats; Type: TABLE DATA; Schema: public; Owner: flight
--

INSERT INTO public.seats VALUES (8, 1, '3B', false, '2024-06-23 20:45:51.59395', '2024-06-23 20:45:51.59395', NULL);
INSERT INTO public.seats VALUES (9, 1, '3C', false, '2024-06-23 20:45:51.59395', '2024-06-23 20:45:51.59395', NULL);
INSERT INTO public.seats VALUES (11, 1, '4B', false, '2024-06-23 20:45:51.59395', '2024-06-23 20:45:51.59395', NULL);
INSERT INTO public.seats VALUES (12, 1, '4C', false, '2024-06-23 20:45:51.59395', '2024-06-23 20:45:51.59395', NULL);
INSERT INTO public.seats VALUES (10, 1, '4A', false, '2024-06-23 20:45:51.59395', '2024-06-23 20:45:51.59395', NULL);
INSERT INTO public.seats VALUES (3, 1, '1C', false, '2024-06-23 20:45:51.59395', '2024-06-24 03:38:42.902287', 'google-oauth2|111539637349807038455');
INSERT INTO public.seats VALUES (4, 1, '2A', false, '2024-06-23 20:45:51.59395', '2024-06-24 03:39:28.086178', 'google-oauth2|111539637349807038455');
INSERT INTO public.seats VALUES (5, 1, '2B', false, '2024-06-23 20:45:51.59395', '2024-06-24 03:47:47.380378', 'google-oauth2|111539637349807038455');
INSERT INTO public.seats VALUES (6, 1, '2C', false, '2024-06-23 20:45:51.59395', '2024-06-24 03:49:58.619964', 'google-oauth2|111539637349807038455');
INSERT INTO public.seats VALUES (7, 1, '3A', false, '2024-06-23 20:45:51.59395', '2024-06-24 13:27:25.752489', 'google-oauth2|111539637349807038455');
INSERT INTO public.seats VALUES (1, 1, '1A', true, '2024-06-23 20:45:51.59395', '2024-06-24 20:14:11.046394', 'google-oauth2|111539637349807038455');
INSERT INTO public.seats VALUES (2, 1, '1B', true, '2024-06-23 20:45:51.59395', '2024-06-25 12:37:22.860265', 'google-oauth2|111539637349807038455');


--
-- TOC entry 3488 (class 0 OID 16447)
-- Dependencies: 222
-- Data for Name: user_modules; Type: TABLE DATA; Schema: public; Owner: flight
--



--
-- TOC entry 3485 (class 0 OID 16418)
-- Dependencies: 219
-- Data for Name: user_profiles; Type: TABLE DATA; Schema: public; Owner: flight
--



--
-- TOC entry 3482 (class 0 OID 16391)
-- Dependencies: 216
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: flight
--



--
-- TOC entry 3520 (class 0 OID 0)
-- Dependencies: 233
-- Name: catalog_items_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.catalog_items_item_id_seq', 1, false);


--
-- TOC entry 3521 (class 0 OID 0)
-- Dependencies: 231
-- Name: catalogs_catalog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.catalogs_catalog_id_seq', 1, false);


--
-- TOC entry 3522 (class 0 OID 0)
-- Dependencies: 223
-- Name: flights_flight_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.flights_flight_id_seq', 8, true);


--
-- TOC entry 3523 (class 0 OID 0)
-- Dependencies: 220
-- Name: modules_module_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.modules_module_id_seq', 5, true);


--
-- TOC entry 3524 (class 0 OID 0)
-- Dependencies: 229
-- Name: notifications_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.notifications_notification_id_seq', 1, false);


--
-- TOC entry 3525 (class 0 OID 0)
-- Dependencies: 227
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, false);


--
-- TOC entry 3526 (class 0 OID 0)
-- Dependencies: 217
-- Name: profiles_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.profiles_profile_id_seq', 1, false);


--
-- TOC entry 3527 (class 0 OID 0)
-- Dependencies: 225
-- Name: reservations_reservation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.reservations_reservation_id_seq', 4, true);


--
-- TOC entry 3528 (class 0 OID 0)
-- Dependencies: 235
-- Name: seats_seat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.seats_seat_id_seq', 12, true);


--
-- TOC entry 3529 (class 0 OID 0)
-- Dependencies: 215
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: flight
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- TOC entry 3325 (class 2606 OID 16549)
-- Name: catalog_items catalog_items_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT catalog_items_pkey PRIMARY KEY (item_id);


--
-- TOC entry 3321 (class 2606 OID 16538)
-- Name: catalogs catalogs_catalog_name_key; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.catalogs
    ADD CONSTRAINT catalogs_catalog_name_key UNIQUE (catalog_name);


--
-- TOC entry 3323 (class 2606 OID 16536)
-- Name: catalogs catalogs_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.catalogs
    ADD CONSTRAINT catalogs_pkey PRIMARY KEY (catalog_id);


--
-- TOC entry 3313 (class 2606 OID 16473)
-- Name: flights flights_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.flights
    ADD CONSTRAINT flights_pkey PRIMARY KEY (flight_id);


--
-- TOC entry 3307 (class 2606 OID 16446)
-- Name: modules modules_module_name_key; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_module_name_key UNIQUE (module_name);


--
-- TOC entry 3309 (class 2606 OID 16444)
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (module_id);


--
-- TOC entry 3319 (class 2606 OID 16520)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (notification_id);


--
-- TOC entry 3317 (class 2606 OID 16503)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 3301 (class 2606 OID 16415)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (profile_id);


--
-- TOC entry 3303 (class 2606 OID 16417)
-- Name: profiles profiles_profile_name_key; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_profile_name_key UNIQUE (profile_name);


--
-- TOC entry 3315 (class 2606 OID 16483)
-- Name: reservations reservations_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_pkey PRIMARY KEY (reservation_id);


--
-- TOC entry 3328 (class 2606 OID 16581)
-- Name: seats seats_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT seats_pkey PRIMARY KEY (seat_id);


--
-- TOC entry 3311 (class 2606 OID 16454)
-- Name: user_modules user_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.user_modules
    ADD CONSTRAINT user_modules_pkey PRIMARY KEY (user_id, module_id);


--
-- TOC entry 3305 (class 2606 OID 16423)
-- Name: user_profiles user_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id, profile_id);


--
-- TOC entry 3295 (class 2606 OID 16404)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 3297 (class 2606 OID 16400)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 3299 (class 2606 OID 16402)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3326 (class 1259 OID 16587)
-- Name: idx_seat_flight_id; Type: INDEX; Schema: public; Owner: flight
--

CREATE INDEX idx_seat_flight_id ON public.seats USING btree (flight_id);


--
-- TOC entry 3336 (class 2606 OID 16550)
-- Name: catalog_items catalog_items_catalog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.catalog_items
    ADD CONSTRAINT catalog_items_catalog_id_fkey FOREIGN KEY (catalog_id) REFERENCES public.catalogs(catalog_id) ON DELETE CASCADE;


--
-- TOC entry 3337 (class 2606 OID 16582)
-- Name: seats fk_flight; Type: FK CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.seats
    ADD CONSTRAINT fk_flight FOREIGN KEY (flight_id) REFERENCES public.flights(flight_id);


--
-- TOC entry 3335 (class 2606 OID 16521)
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3334 (class 2606 OID 16504)
-- Name: payments payments_reservation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_reservation_id_fkey FOREIGN KEY (reservation_id) REFERENCES public.reservations(reservation_id) ON DELETE CASCADE;


--
-- TOC entry 3333 (class 2606 OID 16489)
-- Name: reservations reservations_flight_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.reservations
    ADD CONSTRAINT reservations_flight_id_fkey FOREIGN KEY (flight_id) REFERENCES public.flights(flight_id) ON DELETE CASCADE;


--
-- TOC entry 3331 (class 2606 OID 16460)
-- Name: user_modules user_modules_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.user_modules
    ADD CONSTRAINT user_modules_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(module_id) ON DELETE CASCADE;


--
-- TOC entry 3332 (class 2606 OID 16455)
-- Name: user_modules user_modules_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.user_modules
    ADD CONSTRAINT user_modules_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- TOC entry 3329 (class 2606 OID 16429)
-- Name: user_profiles user_profiles_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(profile_id) ON DELETE CASCADE;


--
-- TOC entry 3330 (class 2606 OID 16424)
-- Name: user_profiles user_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: flight
--

ALTER TABLE ONLY public.user_profiles
    ADD CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


-- Completed on 2024-06-25 09:52:14

--
-- PostgreSQL database dump complete
--

