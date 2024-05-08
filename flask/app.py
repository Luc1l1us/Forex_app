import firebase_admin
from firebase_admin import credentials, db, initialize_app
from flask import Flask, request, jsonify
from firebase import firebase
from flask_cors import CORS
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

@app.route("/")
def home():
    result = firebase.get('/therapists', None)
    return str(result)

# TODO try to use firebase_admin instead of primitive methods like this
@app.route('/add', methods=['POST'])
def add_therapist():
    therapistdata = request.json
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

    result = firebase.post('/therapists', add_therapistdata)

    response_data = {
        'id': result['name'],
        'name': name,
        'occupation': occupation
    }

    return jsonify(response_data), 201

@app.route('/gettherapists', methods=['GET'])
def get_therapists():
    therapist_ref = db.reference('therapists')
    therapists = therapist_ref.get()
    return jsonify(therapists)

@app.route('/therapists/<therapist_id>', methods=['DELETE'])
def del_therapist(therapist_id):
    therapist_ref = db.reference('therapists')
    therapist_ref.child(therapist_id).delete()
    return '', 204

@app.route('/update/<therapist_id>', methods=['PUT'])
def update_therapist(therapist_id):
    try:
        data = request.json
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
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)