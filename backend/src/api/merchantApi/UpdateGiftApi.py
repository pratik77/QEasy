import subprocess, os, time
import re
from flask_restful import Resource, Api, reqparse
from flask import request
import logging, threading
import shutil
from models.model import Slot
from utils.database import db
import json
import copy
from sqlalchemy import or_
import random,string
import calendar;
import time;
from datetime import datetime,timedelta
from sqlalchemy import and_
from models.model import Merchant_Gift

class UpdateGiftApi(Resource):

    def post(self):
        
        try: 
            request_data = request.data
            amount = request_data["amount"]
            gift_name = request_data["giftName"]
            gift_id = request_data["giftId"]

            gift=Merchant_Gift.query.filter_by(id=gift_id, status = "active").first()
            if gift is None:
                message="Gift does not exist"
                return self.response("200","true","",message)
            gift.amount = amount
            gift.gift_name=gift_name
            db.session.add(gift)
            db.session.commit()
            message = "success"
            return self.response("200","false",{},message)
        except Exception as err:
            message = str(err)
            return self.response("503", "true",{}, message)


    def response(self, responseCode,hasError,data,message):
        response = {}
        response['responseCode'] = responseCode
        response['message'] = message
        response['hasError'] = hasError
        response['data'] = data
        return response