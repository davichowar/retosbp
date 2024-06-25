import os
import math
from flask import Flask, request, jsonify, _request_ctx_stack, abort
from flask_cors import CORS, cross_origin
from flask_sqlalchemy import SQLAlchemy
from flask_restful import Resource, Api
import pytz
from datetime import datetime, timedelta, date
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import and_, or_, func, extract, literal
from sqlalchemy.orm import aliased
from app import config as config
import logging
import json
from flask_marshmallow import Marshmallow
import stripe

# DECLARATIVE MODE
from app.models import (
    User,
    Profile,
    Module,
    Flight,
    Reservation,
    Payment,
    Notification,
    Catalog,
    CatalogItem,
    Seat,
)
from app.db import db_session, engine

import base64

from sqlalchemy.sql.expression import cast
import sqlalchemy


# JWT AUTH0
from six.moves.urllib.request import urlopen
from functools import wraps
from jose import jwt

# PASSWORDS
import secrets

AUTH0_DOMAIN = os.getenv("AUTH0_DOMAIN", None)
ALGORITHMS = os.getenv("ALGORITHMS", None)
AUTH0_AUDIENCE = os.getenv("AUTH0_AUDIENCE", None)

STRIPE_SECRET_KEY = os.getenv("STRIPE_SECRET_KEY", None)


archivo_log = os.path.join(os.path.dirname(os.path.abspath(__file__)), "api-rest.log")
logging.basicConfig(level=logging.WARNING, filename=archivo_log)

app = Flask(__name__)
CORS(app)
app.config.from_object(config)
ma = Marshmallow(app)

api = Api(app)

# ENVÍO DE EMAILS
emailFrom = "notificaciones@alchimia-innovation.com"

app.config["AUTH0_DOMAIN"] = AUTH0_DOMAIN
app.config["API_IDENTIFIER"] = AUTH0_AUDIENCE
app.config["ALGORITHMS"] = ALGORITHMS

app.config["STRIPE_SECRET_KEY"] = STRIPE_SECRET_KEY


@app.teardown_appcontext
def shutdown_session(exception=None):
    db_session.remove()


# AUTH0
class AuthError(Exception):
    def __init__(self, error, status_code):
        self.error = error
        self.status_code = status_code


def get_token_auth_header():
    """Obtains the Access Token from the Authorization Header"""
    auth = request.headers.get("Authorization", None)
    if not auth:
        raise AuthError(
            {
                "code": "authorization_header_missing",
                "description": "Authorization header is expected.",
            },
            401,
        )

    parts = auth.split()

    if parts[0].lower() != "bearer":
        raise AuthError(
            {
                "code": "invalid_header",
                "description": 'Authorization header must start with "Bearer".',
            },
            401,
        )

    elif len(parts) == 1:
        raise AuthError(
            {"code": "invalid_header", "description": "Token not found."}, 401
        )

    elif len(parts) > 2:
        raise AuthError(
            {
                "code": "invalid_header",
                "description": "Authorization header must be bearer token.",
            },
            401,
        )

    token = parts[1]
    return token


def requires_auth(f):
    """Determines if the Access Token is valid"""

    @wraps(f)
    def decorated(*args, **kwargs):
        token = get_token_auth_header()
        jsonurl = urlopen(f"https://{AUTH0_DOMAIN}/.well-known/jwks.json")
        jwks = json.loads(jsonurl.read())
        unverified_header = jwt.get_unverified_header(token)
        rsa_key = {}
        for key in jwks["keys"]:
            if key["kid"] == unverified_header["kid"]:
                rsa_key = {
                    "kty": key["kty"],
                    "kid": key["kid"],
                    "use": key["use"],
                    "n": key["n"],
                    "e": key["e"],
                }
        if rsa_key:
            try:
                payload = jwt.decode(
                    token,
                    rsa_key,
                    algorithms=ALGORITHMS,
                    audience=API_AUDIENCE,
                    issuer="https://" + AUTH0_DOMAIN + "/",
                )

            except jwt.ExpiredSignatureError:
                raise AuthError(
                    {"code": "token_expired", "description": "Token expired."}, 401
                )

            except jwt.JWTClaimsError:
                raise AuthError(
                    {
                        "code": "invalid_claims",
                        "description": "Incorrect claims. Please, check the audience and issuer.",
                    },
                    401,
                )
            except Exception:
                raise AuthError(
                    {
                        "code": "invalid_header",
                        "description": "Unable to parse authentication token.",
                    },
                    400,
                )

            _request_ctx_stack.top.current_user = payload
            return f(*args, **kwargs)

        raise AuthError(
            {
                "code": "invalid_header",
                "description": "Unable to find the appropriate key.",
            },
            400,
        )

    return decorated


# ********************************* MODULOS ********************************* #


class ModuleRest(Resource):
    # @cross_origin(headers=["Content-Type", "Authorization"])
    # @requires_auth
    def get(self):
        try:
            modulos_db = Module.query.all()
            modulos_schema = ModuleSchema(many=True)
            modulos = modulos_schema.dump(modulos_db)

            return jsonify({"codigo": 200, "mensaje": "Success", "modulos": modulos})
        except (SQLAlchemyError, TimeoutError) as e:
            return {"codigo": 500, "mensaje": str(e)}

    # @cross_origin(headers=["Content-Type", "Authorization"])
    # @requires_auth
    def post(self):
        data = request.json
        new_flight = Flight(
            airline=data["airline"],
            flight_number=data["flight_number"],
            departure_airport=data["departure_airport"],
            arrival_airport=data["arrival_airport"],
            departure_time=data["departure_time"],
            arrival_time=data["arrival_time"],
            price=data["price"],
        )
        db_session.add(new_flight)
        db_session.commit()

        flight_schema = FlightSchema()

        return flight_schema.jsonify(new_flight), 201

    # @cross_origin(headers=["Content-Type", "Authorization"])
    # @requires_auth
    def put(self):

        tz = pytz.timezone("America/Guayaquil")
        ec_now = datetime.now(tz)

        centro_rq = request.json["centro"]
        centro_db = Module.query.get(centro_rq["idcentro"])

        if centro_rq["module_name"] is not None:
            centro_db.module_name = centro_rq["module_name"]
        if centro_rq["description"] is not None:
            centro_db.description = centro_rq["description"]
        if centro_rq["icon"] is not None:
            centro_db.icon = centro_rq["icon"]
        if centro_rq["path"] is not None:
            centro_db.path = centro_rq["path"]

        try:
            db_session.merge(centro_db)
            db_session.commit()

            return {"codigo": 200, "mensaje": "Success"}
        except (SQLAlchemyError, TimeoutError) as e:
            db_session.rollback()

            return {"codigo": 500, "mensaje": str(e)}


# RUTAS
api.add_resource(ModuleRest, "/module")


# SCHEMAS
class ModuleSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        include_fk = True
        model = Module
        load_instance = True


class FlightSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        include_fk = True
        model = Flight
        load_instance = True


class ReservationSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        include_fk = True
        model = Reservation
        load_instance = True


class SeatSchema(ma.SQLAlchemyAutoSchema):
    class Meta:
        model = Seat
        load_instance = True


flight_schema = FlightSchema()
flights_schema = FlightSchema(many=True)
reservation_schema = ReservationSchema()
reservations_schema = ReservationSchema(many=True)
seat_schema = SeatSchema()
seats_schema = SeatSchema(many=True)


@app.route("/flights", methods=["GET"])
def get_flights():
    flights = Flight.query.all()
    return jsonify(flights_schema.dump(flights))


@app.route("/flights/<int:flight_id>", methods=["GET"])
def get_flight(flight_id):
    flight = Flight.query.get_or_404(flight_id)
    return flight_schema.jsonify(flight)


@app.route("/flights", methods=["POST"])
def create_flight():
    data = request.json
    new_flight = Flight(
        airline=data["airline"],
        flight_number=data["flight_number"],
        departure_airport=data["departure_airport"],
        arrival_airport=data["arrival_airport"],
        departure_time=data["departure_time"],
        arrival_time=data["arrival_time"],
        price=data["price"],
    )
    db_session.add(new_flight)
    db_session.commit()
    return flight_schema.jsonify(new_flight), 201


@app.route("/flights/<int:flight_id>", methods=["PUT"])
def update_flight(flight_id):
    flight = Flight.query.filter_by(flight_id=flight_id)
    data = request.json
    flight.airline = data["airline"]
    flight.flight_number = data["flight_number"]
    flight.departure_airport = data["departure_airport"]
    flight.arrival_airport = data["arrival_airport"]
    flight.departure_time = data["departure_time"]
    flight.arrival_time = data["arrival_time"]
    flight.price = data["price"]
    db_session.commit()
    return flight_schema.jsonify(flight)


@app.route("/flights/<int:flight_id>", methods=["DELETE"])
def delete_flight(flight_id):
    flight = Flight.query.get_or_404(flight_id)
    db_session.delete(flight)
    db_session.commit()
    return "", 204


# Rutas para reservas
@app.route("/reservations", methods=["GET"])
def get_reservations():
    reservations = Reservation.query.all()
    return jsonify(reservations_schema.dump(reservations))


@app.route("/reservations/<int:reservation_id>", methods=["GET"])
def get_reservation(reservation_id):
    reservation = Reservation.query.get_or_404(reservation_id)
    return reservation_schema.jsonify(reservation)


@app.route("/reservations", methods=["POST"])
def create_reservation():
    data = request.json
    new_reservation = Reservation(
        user_id=data["user_id"],
        flight_id=data["flight_id"],
        reservation_status=data["reservation_status"],
        seat_number=data["seat_number"],
    )
    db_session.add(new_reservation)
    db_session.commit()
    return reservation_schema.jsonify(new_reservation), 201


@app.route("/reservations/<int:reservation_id>", methods=["PUT"])
def update_reservation(reservation_id):
    reservation = Reservation.query.filter_by(reservation_id=reservation_id)
    data = request.json
    reservation.user_id = data["user_id"]
    reservation.flight_id = data["flight_id"]
    reservation.reservation_status = data["reservation_status"]
    reservation.seat_number = data["seat_number"]
    db_session.commit()
    return reservation_schema.jsonify(reservation)


@app.route("/reservations/<int:reservation_id>", methods=["DELETE"])
def delete_reservation(reservation_id):
    reservation = Reservation.query.get_or_404(reservation_id)
    db_session.delete(reservation)
    db_session.commit()
    return "", 204


# Rutas para pagos con Stripe
@app.route("/pay/<int:reservation_id>", methods=["POST"])
def pay_reservation(reservation_id):
    reservation = Reservation.query.get_or_404(reservation_id)

    try:
        # Logica de pago con Stripe
        payment_intent = stripe.PaymentIntent.create(
            amount=int(reservation.flight.price * 100),  # Convertir a centavos
            currency="usd",
            payment_method_types=["card"],
        )

        return jsonify({"client_secret": payment_intent.client_secret}), 200

    except stripe.error.StripeError as e:
        return jsonify(error=str(e)), 400


# RUTAS DE ASIENTOS
@app.route("/flights/<int:flight_id>/seats", methods=["GET"])
def get_seats(flight_id):
    seats = Seat.query.filter_by(flight_id=flight_id).all()
    return seats_schema.jsonify(seats)


@app.route("/seats/<int:seat_id>", methods=["PUT"])
def update_seat(seat_id):
    tz = pytz.timezone("America/Guayaquil")
    ec_now = datetime.now(tz)

    data = request.json

    seat = Seat.query.get(seat_id)
    if seat is None:
        abort(404, description="Seat not found")

    is_occupied = request.json.get("is_occupied")
    user_id = request.json.get("user_id")
    if is_occupied is not None:
        seat.is_occupied = is_occupied
        seat.user_id = user_id
        seat.updated_at = ec_now
        db_session.commit()
        return seat_schema.jsonify(seat)

    return jsonify({"error": "Invalid input"}), 400
