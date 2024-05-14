import firebase_admin
from firebase_admin import credentials, db, initialize_app
from flask import Flask, request, jsonify
from firebase import firebase
from flask_cors import CORS
<<<<<<< HEAD
import requests

app = Flask(__name__)
CORS(app)
firebase = firebase.FirebaseApplication(
    "https://gen-lang-client-0909444084-default-rtdb.firebaseio.com", None
)
# cred = credentials.Certificate(
#    "/home/dizzy/Downloads/gen-lang-client-0909444084-default-rtdb-export.json"
# )  # Linux
# cred = credentials.Certificate("D:\Downloads\gen-lang-client-0909444084-firebase-adminsdk-2nfej-61b29242e5.json") #Windows
# firebase_admin.initialize_app(
#    cred,
#    {"databaseURL": "https://gen-lang-client-0909444084-default-rtdb.firebaseio.com"},
# )
# firebase = FirebaseAdmin(app)

default_app = firebase_admin.initialize_app()

=======
from dotenv import load_dotenv
import os

pathtoenv = 'app\.env'
load_dotenv(pathtoenv)

databaseURL = os.getenv("FIREBASE_DATABASE_URL")
certpath = os.getenv("PATH_TO_CERT")

app = Flask(__name__)
CORS(app)
firebase = firebase.FirebaseApplication('https://gen-lang-client-0909444084-default-rtdb.firebaseio.com', None)
cred = credentials.Certificate("D:\Downloads\gen-lang-client-0909444084-firebase-adminsdk-2nfej-61b29242e5.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://gen-lang-client-0909444084-default-rtdb.firebaseio.com',
})
>>>>>>> 91abcea35c65eb90d553604675295673775470cb

@app.route("/")
def home():
    result = firebase.get("/therapists", None)
    return str(result)


# TODO try to use firebase_admin instead of primitive methods like this
@app.route("/add", methods=["POST"])
def add_therapist():
    therapistdata = request.json
<<<<<<< HEAD
    name = therapistdata.get("name")
    occupation = therapistdata.get("occupation")

    if not name or not occupation:
        return jsonify({"error": "Name and occupation fields are required!"}), 400
=======
    name = therapistdata.get('name')
    occupation = therapistdata.get('occupation')
    contact = therapistdata.get('contact')
    department = therapistdata.get('department')

    if not name or not occupation:
        return jsonify({
            'error': 'Name and occupation fields are required!'
        }), 400
    
    add_therapistdata = {
        'name': name,
        'occupation': occupation,
        'contact': contact,
        'department': department,
    }
>>>>>>> 91abcea35c65eb90d553604675295673775470cb

    add_therapistdata = {"name": name, "occupation": occupation}

    result = firebase.post("/therapists", add_therapistdata)

    response_data = {"id": result["name"], "name": name, "occupation": occupation}

    return jsonify(response_data), 201


@app.route("/gettherapists", methods=["GET"])
def get_therapists():
    therapist_ref = db.reference("therapists")
    therapists = therapist_ref.get()
    return jsonify(therapists)
<<<<<<< HEAD
    # alltherapists = firebase.get('/therapists', None)
    # return jsonify(alltherapists), 200
=======
>>>>>>> 91abcea35c65eb90d553604675295673775470cb


@app.route("/therapists/<therapist_id>", methods=["DELETE"])
def del_therapist(therapist_id):
    therapist_ref = db.reference("therapists")
    therapist_ref.child(therapist_id).delete()
    return "", 204


@app.route("/update/<therapist_id>", methods=["PUT"])
def update_therapist(therapist_id):
    try:
        data = request.json
<<<<<<< HEAD
        updated_name = data.get("name")
        updated_occ = data.get("occupation")

        therapist_ref = db.reference("therapists")
        therapist_ref.child(therapist_id).update(
            {
                "name": updated_name,
                "occupation": updated_occ,
            }
        )
        return jsonify({"message": "Therapist updated successfully"}), 200
=======
        updated_name = data.get('name')
        updated_occ = data.get('occupation')
        updated_contact = data.get('contact')
        updated_dep = data.get('department')


        therapist_ref = db.reference('therapists')
        therapist_ref.child(therapist_id).update({
            'name': updated_name,
            'occupation': updated_occ,
            'contact': updated_contact,
            'department': updated_dep,
        })
        return jsonify({'message': 'Therapist updated successfully'}), 200
>>>>>>> 91abcea35c65eb90d553604675295673775470cb
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@app.route("/forexupdate", methods=["GET"])
def get_forexupdate():
    get_forex = "https://api.twelvedata.com/time_series?symbol=AAPL,EUR/USD,IXIC&interval=1min&apikey=demo"
    # get_forex = "https://api.twelvedata.com/time_series?symbol=AAPL,EUR/USD,ETH/BTC:Huobi,TRP:TSX&interval=1min&apikey=1308290194f14fd8874b793fd1839f43"
    response = requests.get(get_forex)
    data = response.json()
    return data, 200


if __name__ == "__main__":
    app.run(debug=True)

