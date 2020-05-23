from flask import render_template
from app import app

@app.route('/')
def home():
    return "É TETRA! É TETRA!"

@app.route('/template')
def template():
    return render_template('home.html')
 
@app.route('/healthcheck')
def heatlhcheck():
    return render_template('hc.html')