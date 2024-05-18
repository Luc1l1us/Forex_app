#!/bin/bash

cd flask
.venv\Scripts\activate #Windows
flask run --debug
source ~/.venv/bin/activate  #Linux
python app.py