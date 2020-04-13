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


class CreateGiftApi(Resource):

    def post(self):
    
        try:    
            request_data = request.data
            merchant_id = request_data["merchantId"]
            amount = request_data["amount"]
            gift_name = request_data["giftName"]
            gifts=Merchant_Gift.query.filter_by(gift_name=gift_name, merchant_id = merchant_id, status = "active")
            giftsInactive = Merchant_Gift.query.filter_by(gift_name=gift_name, merchant_id = merchant_id, amount = amount, status = "inactive")
            if(gifts.count()>0):
                message="Gift already exist"
                return self.response("200","true","",message)
            elif giftsInactive.count() > 0:
                gift=giftsInactive.first()
                gift.status = "active"
                message = 'success'
                db.session.add(gift)
                db.session.commit()
                return self.response("200","true","",message)
            gift=Merchant_Gift(merchant_id=merchant_id,gift_name=gift_name,amount=amount, status = "active")
            db.session.add(gift)
            db.session.commit()
            message = "success"
            return self.response("200","false",{"giftId":gift.id},message)
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