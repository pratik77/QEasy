import 'package:covidpass/enums/user_role.dart';
import 'package:covidpass/provider/home_notifier.dart';
import 'package:covidpass/provider/profile_notifier.dart';
import 'package:covidpass/provider/slot_notifier.dart';
import 'package:covidpass/screens/coupons.dart';
import 'package:covidpass/screens/home.dart';
import 'package:covidpass/screens/items.dart';
import 'package:covidpass/screens/notifications.dart';
import 'package:covidpass/screens/profile.dart';
import 'package:covidpass/screens/qr_code.dart';
import 'package:covidpass/screens/scan_qr.dart';
import 'package:covidpass/utils/colors.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:covidpass/utils/user_role_serializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  final int initialIndex;

  Dashboard({this.initialIndex = 0});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex;
  final List<Widget> _children = SharedPrefUtils.get(Constants.USER_TYPE) ==
          UserRoleSerializer.getRoleFromEnum(UserRole.CUSTOMER)
      ? [
          Home(),
          QrCode(),
          Notifications(),
          Profile(),
        ]
      : SharedPrefUtils.get(Constants.USER_TYPE) ==
              UserRoleSerializer.getRoleFromEnum(UserRole.MERCHANT)
          ? [
              ScanQr(),
              Items(),
              Coupons(),
              Profile(),
            ]
          : [
              ScanQr(),
              Profile(),
            ];

  @override
  void initState() {
    _currentIndex = widget.initialIndex;
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          onTabTapped(0);
          return false;
        }
        return true;
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => HomeNotifier(
                SharedPrefUtils.get(Constants.LAT),
                SharedPrefUtils.get(Constants.LONG)),
          ),
          ChangeNotifierProvider(
            create: (context) => SlotNotifier(
                SharedPrefUtils.get(Constants.USER_ID),
                isFromSuccess: false),
          ),
          ChangeNotifierProvider(
            create: (context) => ProfileNotifier(
              SharedPrefUtils.get(Constants.USER_ID),
              SharedPrefUtils.get(Constants.USER_TYPE),
            ),
          )
        ],
        child: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              selectedItemColor: BottomNavItemColor,
              unselectedItemColor: BottomNavItemColor,
              backgroundColor: PrimaryDarkColor,
              type: BottomNavigationBarType.fixed,
              onTap: onTabTapped,
              currentIndex: _currentIndex,
              items: SharedPrefUtils.get(Constants.USER_TYPE) ==
                      UserRoleSerializer.getRoleFromEnum(UserRole.CUSTOMER)
                  ? [
                      _buildNavigationItem("Home", "assets/vectors/home.svg"),
                      _buildNavigationItem(
                          "QR Code", "assets/vectors/qr_code.svg"),
                      _buildNavigationItem(
                          "Notifications", "assets/vectors/notification.svg"),
                      _buildNavigationItem(
                          "Profile", "assets/vectors/profile.svg"),
                    ]
                  : SharedPrefUtils.get(Constants.USER_TYPE) ==
                          UserRoleSerializer.getRoleFromEnum(UserRole.MERCHANT)
                      ? [
                          _buildNavigationItem(
                              "QR Code", "assets/vectors/qr_code.svg"),
                          _buildNavigationItem(
                              "Items", "assets/vectors/ic_bullet_list.svg"),
                          _buildNavigationItem(
                              "Coupons", "assets/vectors/ic_coupon.svg"),
                          _buildNavigationItem(
                              "Profile", "assets/vectors/profile.svg"),
                        ]
                      : [
                          _buildNavigationItem(
                              "QR Code", "assets/vectors/qr_code.svg"),
                          _buildNavigationItem(
                              "Profile", "assets/vectors/profile.svg"),
                        ],
            ),
          ),
        ),
      ),
    );
  }

  _buildNavigationItem(String title, String iconPath) {
    return BottomNavigationBarItem(
      icon: Column(
        children: <Widget>[
          Container(
            width: 30,
            height: 3,
          ),
          SizedBox(
            height: 8.0,
          ),
          SvgPicture.asset(iconPath),
        ],
      ),
      activeIcon: Column(
        children: <Widget>[
          Container(
            width: 30,
            height: 3,
            color: Colors.white,
          ),
          SizedBox(
            height: 8.0,
          ),
          SvgPicture.asset(
            iconPath,
            color: BottomNavItemColor,
            height: 24,
          ),
        ],
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
