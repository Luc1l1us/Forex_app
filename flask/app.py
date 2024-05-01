from flask import Flask, request, jsonify
from firebase import firebase
from flask_cors import CORS
from firebase_admin import credentials, initialize_app, db

app = Flask(__name__)
CORS(app)
firebase = firebase.FirebaseApplication('https://gen-lang-client-0909444084-default-rtdb.firebaseio.com', None)
#cred = credentials.Certificate('AIzaSyA1kZCh77GgPdJfjSmE-ZuKjddmebWKvzE')
default_app = firebase_admin.initialize_app()
#firebaseadmin = initialize_app(cred, {'databaseURL': 'https://gen-lang-client-0909444084-default-rtdb.firebaseio.com'})
#firebase = FirebaseAdmin(app)

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

    if not name or not occupation:
        return jsonify({
            'error': 'Name and occupation fields are required!'
        }), 400
    
    add_therapistdata = {
        'name': name,
        'occupation': occupation
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
    alltherapists = firebase.get('/therapists', None)
    return jsonify(alltherapists), 200

if __name__ == "__main__":
    app.run(debug=True)