from flask import Flask, request
from firebase import firebase

app = Flask(__name__)
firebase = firebase.FirebaseApplication('https://gen-lang-client-0909444084-default-rtdb.firebaseio.com', None)

@app.route("/")
def home():
    result = firebase.get('/therapists', None)
    return str(result)

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST' and len(dict(request.form)) > 0:
        userdata = dict(request.form)
        name = userdata["name"][0]
        password = userdata["password"][0]
        email = userdata["email"][0]
        postData = {"name": name, "password": password, "email":email}
        firebase.post("/therapists", postData)
        return "Thank you!"
    else:
        return "Error has occured!"


if __name__ == "__main__":
    app.run(debug=True)