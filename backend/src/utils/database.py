from flask_api import FlaskAPI, status, exceptions
from flask_restful import Resource, Api, reqparse
from flask_cors import CORS, cross_origin
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate


app = FlaskAPI(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://dbUser:access@3.17.180.234/covid'
#app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///covid4New.db'
db = SQLAlchemy(app)
migrate = Migrate(app, db, compare_type=True)