from utils.database import db
import datetime
from sqlalchemy.ext.hybrid import hybrid_method
from sqlalchemy.sql.expression import func
import math
from geoalchemy2.types import Geometry

class Users(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    phonenumber = db.Column(db.String(80), nullable=False)
    firstname = db.Column(db.String(80))
    lastname = db.Column(db.String(80))
    passwordhash = db.Column(db.String(80))
    references = db.Column(db.String(80))

    def __repr__(self):
        return "(%r, %r, %r, %r)" % (self.phonenumber, self.firstname, self.lastname, self.passwordhash)


class Roles(db.Model):
    __tablename__ = 'roles'
    id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    roleType = db.Column(db.String(80), nullable=False)


class User_Roles(db.Model):
    __tablename__ = 'user_roles'
    id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    #user = db.relationship("Users", backref=db.backref("users", uselist=False))
    role_id = db.Column(db.Integer, db.ForeignKey('roles.id'))
    #role = db.relationship("Roles", backref=db.backref("roles", uselist=False))


class NormalUser(db.Model):
    __tablename__ = 'normal_user'
    normal_user_id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    electricity_bill_number = db.Column(db.String(80), nullable=False)
    lat = db.Column(db.String(80))
    lng = db.Column(db.String(80))
    #geom = db.Column(Geometry(geometry_type='POINT', srid=4326))
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    #user = db.relationship("Users", backref=db.backref("Users", uselist=False))

def gc_distance(lat1, lng1, lat2, lng2, math=math):
    # import pdb; pdb.set_trace()
    # dst = (3958.75 *
    #        math.acos(math.sin(float(lat1) / 57.2959) * math.sin(float(latitude) / 57.2960) +
    #                  math.cos(float(lat1) / 57.2958) * math.cos(float(latitude) / 57.2958) *
    #                  math.cos(longitude / 57.2958 - float(lon1)/57.2958)))
    # return dst

    ang = math.acos(math.cos(math.radians(lat1)) *
                    math.cos(math.radians(lat2)) *
                    math.cos(math.radians(lng2) -
                             math.radians(lng1)) +
                    math.sin(math.radians(lat1)) *
                    math.sin(math.radians(lat2)))

    return 6371 * ang
    
    

class Merchant(db.Model):
    __tablename__ = 'Merchant'
    merchant_id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    shopName = db.Column(db.String(80), nullable=False)
    gstNumber = db.Column(db.String(80), nullable=False)
    shopCategory = db.Column(db.String(80), nullable=False)
    avgTime = db.Column(db.String(80), nullable=False)
    maxPeoplePerSlot = db.Column(db.String(80), nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    lat = db.Column(db.String(80))
    lng = db.Column(db.String(80))
    #geom = db.Column(Geometry(geometry_type='POINT', srid=4326))
    
    @hybrid_method
    def distance(self, lat, lng):
        return gc_distance(lat, lng, float(self.lat), float(self.lng))

    @distance.expression
    def distance(cls, lat, lng):
        return gc_distance(lat, lng, cls.lat.cast(db.Float), cls.lng.cast(db.Float), math=func)
    # user = db.relationship("Users", backref=db.backref("Users", uselist=False))

class Shop_Item(db.Model):
    __tablename__ = 'shop_item'
    id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    merchant_id = db.Column(db.Integer, db.ForeignKey('Merchant.merchant_id'))
    #merchant = db.relationship("Merchant", backref=db.backref("merchant", uselist=False))
    item_value = db.Column(db.String(80), nullable=False)
    status = db.Column(db.String(80), nullable=False)


class Slot(db.Model):
    __tablename__ = 'slot'
    slot_id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    startime = db.Column(db.Integer)
    endTime = db.Column(db.Integer)
    booking_date = db.Column(db.DateTime, default=datetime.datetime.utcnow)
    status = db.Column(db.String(80), nullable=False)
    qrCode = db.Column(db.String(80), nullable=True)
    current_count= db.Column(db.Integer, nullable=True)
    #merchant = db.relationship("Merchant", backref=db.backref("merchant", uselist=False))
    merchant_id = db.Column(db.Integer,  db.ForeignKey('Merchant.merchant_id'))
    user_id = db.Column(db.Integer, db.ForeignKey('normal_user.normal_user_id'))
    #user = db.relationship("Users", backref=db.backref("users", uselist=False))

class Merchant_Gift(db.Model):
    __tablename__ = 'merchant_gift'
    __table_args__ = {'extend_existing': True} 
    id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    amount = db.Column(db.String(80), nullable=False)
    gift_name = db.Column(db.String(80), nullable=False)
    merchant_id = db.Column(db.Integer,  db.ForeignKey('Merchant.merchant_id'))
    status = db.Column(db.String(80), nullable=False)

class User_Gift(db.Model):
    __tablename__ = 'user_gift'
    __table_args__ = {'extend_existing': True} 
    id = db.Column(db.Integer, primary_key=True,autoincrement=True)
    gift_id = db.Column(db.Integer,  db.ForeignKey('merchant_gift.id'))
    booking_date = db.Column(db.DateTime, default=datetime.datetime.utcnow)
    expiry_date = db.Column(db.DateTime, default=datetime.datetime.utcnow)
    user_id = db.Column(db.Integer,  db.ForeignKey('normal_user.normal_user_id'))
    status =  db.Column(db.String(80))

db.create_all()
db.session.commit()

# class Item(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     item_name = db.Column(db.String(80), nullable=False)