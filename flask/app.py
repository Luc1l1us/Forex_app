import firebase_admin
from firebase_admin import credentials, db, initialize_app
from flask import Flask, request, jsonify
from firebase import firebase
from flask_cors import CORS
import requests
import os
from dotenv import load_dotenv

app = Flask(__name__)
CORS(app)
load_dotenv()
firebase = firebase.FirebaseApplication(
    os.getenv("DATABASE_URL"), None
)
# cred = credentials.Certificate(
#    "/home/dizzy/Downloads/gen-lang-client-0909444084-default-rtdb-export.json"
# )  # Linux
cred = credentials.Certificate(os.getenv("CRED_CERTIFICATE")) #Windows
firebase_admin.initialize_app(
    cred,
    {
        "databaseURL": os.getenv("DATABASE_URL")
    },
)

# TODO try to use firebase_admin instead of primitive methods like this
@app.route("/add", methods=["POST"])
def add_therapist():
    userdata = request.json
    uid = userdata.get("uid")
    email = userdata.get("email")
    fname = userdata.get("firstname")
    lname = userdata.get("lastname")
    bdate = userdata.get("birthday")

    if not email or not fname or not lname or not uid or not bdate:
        return jsonify({"error": "uid, email, name, and bdate fields are required!"}), 400

    add_userdata = {
        "First Name": fname, 
        "Last Name": lname, 
        "email": email,
        "birthday": bdate,
    }
    user_ref = db.reference(f"/therapists/{uid}")
    user_ref.set(add_userdata)
    response_data = {"First Name": fname, "Last Name": lname, "email": email, "birthday": bdate}
    return jsonify(response_data), 201

@app.route("/update/<userId>", methods=["PUT"])
def update_userdata(userId):
    try:
        data = request.json
        print(data)
        field_to_update = data.get("field")
        updated_value = data.get("value")
        print(field_to_update, updated_value)
        
        user_ref = db.reference(f"/therapists/{userId}")
        
        if field_to_update == "firstname":
            user_ref.update({"First Name": updated_value})
        elif field_to_update == "lastname":
            user_ref.update({"Last Name": updated_value})
        elif field_to_update == "username":
            user_ref.update({"Username": updated_value})
        else:
            return jsonify({"error": "Invalid field"}), 400

        return jsonify({"message": "User data updated successfully"}), 200
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

    
@app.route("/delete/<userId>", methods=["DELETE"])
def del_user(userId):
    therapist_ref = db.reference("therapists")
    therapist_ref.child(userId).delete()
    return "", 204

""" @app.route("/therapists/<therapist_id>", methods=["DELETE"])
def del_therapist(therapist_id):
    therapist_ref = db.reference("therapists")
    therapist_ref.child(therapist_id).delete()
    return "", 204 """

@app.route('/exchangecurrency', methods=["GET"])
def exchange_currency():
    symbols = request.args.get('symbol')
    amount = request.args.get('amount')
    if not symbols or amount is None:
        return jsonify({"error": "Symbols and amount parameter is required"}), 400

    twelve_currexchange = os.environ.get('TWELVE_DATA_EXCHANGE_URL')
    twelvekey = os.environ.get('TWELVE_API')

    url = f"{twelve_currexchange}?symbol={symbols}&amount={amount}&apikey={twelvekey}"
    response = requests.get(url)
    return jsonify(response.json()), 200

@app.route('/searchforex', methods=["GET"])
def get_searchstocks():
    symbols = request.args.get('symbols')
    if not symbols:
        return jsonify({"error": "Symbols parameter is required"}), 400

    twelve_searchstocks = os.environ.get('TWELVE_DATA_SEARCH_URL')
    twelvekey = os.environ.get('TWELVE_API')

    url = f"{twelve_searchstocks}?symbol={symbols}"
    response = requests.get(url)

    return jsonify(response.json()), 200

@app.route("/get_stocks", methods=["GET"])
def get_stocks():
    symbols = request.args.get('symbols')
    if not symbols:
        return jsonify({"error": "Symbols parameter is required"}), 400
    
    stock_data = []
    
    twelve_quoteurl = os.environ.get('TWELVE_DATA_BASE_URL')
    twelve_logourl = os.environ.get('TWELVE_DATA_LOGO_URL')
    twelvekey = os.environ.get('TWELVE_API')

    url = f"{twelve_quoteurl}?symbol={symbols}&apikey={twelvekey}"
    response = requests.get(url)

    logourl = f"{twelve_logourl}?symbol={symbols}&apikey={twelvekey}"
    logo_respose = requests.get(logourl)

    return jsonify(response.json()), 200

@app.route("/getusers/<userId>", methods=["GET"])
def get_user(userId):
    user_ref = db.reference(f"/therapists/{userId}")
    user_data = user_ref.get()
    #user_data = user_ref.child(userId).get()
    if user_data:
        return jsonify(user_data), 200
    else:
        return jsonify({"error": "User not found"}), 404

@app.route("/therapists/<therapist_id>", methods=["DELETE"])
def del_therapist(therapist_id):
    therapist_ref = db.reference("therapists")
    therapist_ref.child(therapist_id).delete()
    return "", 204

@app.route("/update/<therapist_id>", methods=["PUT"])
def update_therapist(therapist_id):
    try:
        data = request.json
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
    except Exception as e:
        return jsonify({"error": str(e)}), 500



if __name__ == "__main__":
    app.run(debug=True)
