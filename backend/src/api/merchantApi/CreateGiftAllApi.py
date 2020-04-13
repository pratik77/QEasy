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


class CreateGiftAllApi(Resource):

    def post(self):
        try:    
            request_data = request.data
            merchant_id = request_data["merchantId"]
            data_gifts = request_data["gifts"]
            giftList=[]
            for gift_request in data_gifts:
               
                gifts=Merchant_Gift.query.filter_by(gift_name=gift_request["giftName"], merchant_id = merchant_id, status = "active")
                giftsInactive = Merchant_Gift.query.filter_by(gift_name=gift_request["giftName"], merchant_id = merchant_id, amount = gift_request["amount"], status = "inactive")
                giftInfo={}
                if giftsInactive.count() > 0:
                    gift=giftsInactive.first()
                    gift.status = "active"
                    message = 'success'
                    db.session.add(gift)
                    db.session.commit()
                    giftInfo["giftId"]=gift.id
                    giftInfo["giftName"]=gift.gift_name
                    giftInfo["amount"]=gift.amount
                    
                elif(gifts.count()==0):
                    gift=Merchant_Gift(merchant_id=merchant_id,gift_name=gift_request["giftName"],amount=gift_request["amount"], status = "active")
                    db.session.add(gift)
                    db.session.commit()
                    giftInfo["giftId"]=gift.id
                    giftInfo["giftName"]=gift.gift_name
                    giftInfo["amount"]=gift.amount

                else:
                    giftInfo["giftId"]=gifts[0].id
                    giftInfo["giftName"]=gifts[0].gift_name
                    giftInfo["amount"]=gifts[0].amount
                giftList.append(giftInfo)
            message = "success"
            return self.response("200","false",giftList,message)
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