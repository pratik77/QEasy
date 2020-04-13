import 'package:covidpass/enums/store_category.dart';
import 'package:covidpass/enums/user_role.dart';
import 'package:covidpass/models/user.dart';
import 'package:covidpass/repository/data_repository.dart';
import 'package:covidpass/screens/dashboard.dart';
import 'package:covidpass/screens/login.dart';
import 'package:covidpass/utils/code_snippets.dart';
import 'package:covidpass/utils/colors.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/form_validation.dart';
import 'package:covidpass/utils/keyboard_utils.dart';
import 'package:covidpass/utils/location_utils.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:covidpass/utils/user_role_serializer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TapGestureRecognizer _loginRecognizer = TapGestureRecognizer();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _billController = TextEditingController();
  TextEditingController _storeNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _allotedCustomersController = TextEditingController();
  TextEditingController _gstController = TextEditingController();
  UserRole _currentUserRole = UserRole.CUSTOMER;
  GlobalKey<FormState> _formKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  StoreCategory _selectedStore;
  bool _showPassword = false;
  Color _storeFieldColor = Colors.grey;
  bool _isSubmitted = false;

  @override
  void initState() {
    _loginRecognizer.onTap = () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
        );
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _billController.dispose();
    _passwordController.dispose();
    _gstController.dispose();
    _allotedCustomersController.dispose();
    _storeNameController.dispose();
    _loginRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => KeyboardUtils.hideKeyboard(context),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: PrimaryDarkColor,
        body: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 24,
                    ),
                    SvgPicture.asset(
                      "assets/vectors/ic_logo.svg",
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Welcome to QEasy",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              flex: 1,
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Text(
                        "Select Your Role",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        height: 56,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        padding: EdgeInsets.all(2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _buildTabItem(UserRole.CUSTOMER),
                            _buildTabItem(UserRole.MERCHANT),
                            _buildTabItem(UserRole.POLICE),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.CUSTOMER ||
                            _currentUserRole == UserRole.POLICE,
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "First Name",
                          ),
                          validator: (value) =>
                              FormValidation.validateFirstName(value),
                        ),
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.CUSTOMER ||
                            _currentUserRole == UserRole.POLICE,
                        child: SizedBox(
                          height: 32,
                        ),
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.CUSTOMER ||
                            _currentUserRole == UserRole.POLICE,
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Last Name",
                          ),
                          validator: (value) =>
                              FormValidation.validateLastName(value),
                        ),
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.MERCHANT,
                        child: TextFormField(
                          controller: _storeNameController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Store Name",
                          ),
                          validator: (value) => FormValidation.validateField(
                            value,
                            "Enter the store name",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          suffixIcon: IconButton(
                              icon: _showPassword
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              }),
                        ),
                        validator: (value) =>
                            FormValidation.validatePassword(value),
                        obscureText: !_showPassword,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.MERCHANT,
                        child: TextFormField(
                          controller: _gstController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "GST ID",
                          ),
                          validator: (value) => FormValidation.validateField(
                            value,
                            "Enter GST number",
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.MERCHANT,
                        child: SizedBox(
                          height: 32,
                        ),
                      ),
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Phone Number",
                        ),
                        validator: (value) =>
                            FormValidation.validatePhone(value),
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.CUSTOMER ||
                            _currentUserRole == UserRole.MERCHANT,
                        child: SizedBox(
                          height: 32,
                        ),
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.CUSTOMER,
                        child: TextFormField(
                          controller: _billController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Electricity Bill Number",
                          ),
                          validator: (value) => FormValidation.validateField(
                            value,
                            "Enter electricity bill number",
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.MERCHANT,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: _storeFieldColor),
                              borderRadius: BorderRadius.circular(4)),
                          child: DropdownButton<StoreCategory>(
                            value: _selectedStore,
                            hint: Text("Select Store Type"),
                            items: [
                              ...StoreCategory.values.skip(1).map(
                                    (it) => DropdownMenuItem<StoreCategory>(
                                      child: Text(
                                        it
                                            .toString()
                                            .split(".")[1]
                                            .split("_")
                                            .join(" "),
                                        style: TextStyle(
                                          color: SecondaryLightTextColor,
                                        ),
                                      ),
                                      value: it,
                                    ),
                                  ),
                            ],
                            onChanged: (category) {
                              setState(() {
                                _selectedStore = category;
                                _storeFieldColor = Colors.grey;
                              });
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.MERCHANT,
                        child: SizedBox(
                          height: 32,
                        ),
                      ),
                      Visibility(
                        visible: _currentUserRole == UserRole.MERCHANT,
                        child: TextFormField(
                          controller: _allotedCustomersController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Alloted no. customers at a time",
                            suffixIcon: Icon(Icons.keyboard_arrow_down),
                          ),
                          validator: (value) => FormValidation.validateField(
                            value,
                            "Enter alloted no. of customers",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: _isSubmitted ? Colors.grey : PrimaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "REGISTER",
                                style: TextStyle(
                                  color: _isSubmitted
                                      ? PrimaryTextColor
                                      : Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Visibility(
                                visible: _isSubmitted,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator()),
                                ),
                              ),
                            ],
                          ),
                          onPressed: _isSubmitted ? null : () => _register(),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Already Registered? ",
                              style: TextStyle(
                                color: PrimaryTextColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              recognizer: _loginRecognizer,
                              text: "SIGN IN",
                              style: TextStyle(
                                color: PrimaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                    ],
                  ),
                ),
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(CodeSnippets.makeSnackBar(message));
  }

  Widget _buildTabItem(UserRole userRole) {
    return InkWell(
      onTap: () {
        setState(() {
          _currentUserRole = userRole;
        });
      },
      child: Container(
        decoration: _currentUserRole == userRole
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: PrimaryDarkColor,
                boxShadow: [
                  BoxShadow(
                    color: CardShadowColor,
                    blurRadius: 1.5,
                    spreadRadius: 0.5,
                  ),
                ],
              )
            : null,
        padding: EdgeInsets.all(16),
        child: Text(
          userRole.toString().split(".")[1],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _currentUserRole == userRole
                ? Colors.white
                : SecondaryLightTextColor,
          ),
        ),
      ),
    );
  }

  _register() async {
    setState(() {
      _isSubmitted = true;
    });
    if (!_formKey.currentState.validate() && _selectedStore == null) {
      setState(() {
        _storeFieldColor = ErrorColor;
        _isSubmitted = false;
      });
      return;
    }
    LocationData locationData = await LocationUtils.getCurrentLocation();
    if (locationData == null) {
      setState(() {
        _isSubmitted = false;
      });
      _showSnackBar("Location is needed to serve you better");
      return;
    }
    User user = User()..userType = _currentUserRole;
    switch (_currentUserRole) {
      case UserRole.CUSTOMER:
        user
          ..firstName = _firstNameController.text
          ..lastName = _lastNameController.text
          ..password = _passwordController.text
          ..phoneNumber = _mobileController.text
          ..electricityBillNumber = _billController.text
          ..lat = locationData.latitude.toString()
          ..lng = locationData.longitude.toString();
        break;
      case UserRole.MERCHANT:
        user
          ..shopName = _storeNameController.text
          ..password = _passwordController.text
          ..gstNumber = _gstController.text
          ..shopCategory = _selectedStore
          ..phoneNumber = _mobileController.text
          ..maxSlots = _allotedCustomersController.text
          ..lat = locationData.latitude.toString()
          ..lng = locationData.longitude.toString();
        break;
      case UserRole.POLICE:
        user
          ..firstName = _firstNameController.text
          ..lastName = _lastNameController.text
          ..password = _passwordController.text
          ..phoneNumber = _mobileController.text;
        break;
      default:
    }

    DataRepository.instance.register(user).then((res) {
      if (res.responseCode == "200" && res.hasError == "false") {
        SharedPrefUtils.setInt(Constants.USER_ID, res.data["userId"]);
        SharedPrefUtils.setString(Constants.USER_TYPE,
            UserRoleSerializer.getRoleFromEnum(_currentUserRole));
        SharedPrefUtils.setDouble(Constants.LAT, locationData.latitude);
        SharedPrefUtils.setDouble(Constants.LONG, locationData.longitude);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false,
        );
      } else {
        setState(() {
          _isSubmitted = false;
        });
        _showSnackBar(res.message);
      }
    }).catchError((e) {
      setState(() {
        _isSubmitted = false;
      });
      _showSnackBar(e.message);
    });
  }
}
