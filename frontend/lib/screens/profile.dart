import 'package:covidpass/enums/user_role.dart';
import 'package:covidpass/provider/profile_notifier.dart';
import 'package:covidpass/screens/login.dart';
import 'package:covidpass/utils/colors.dart';
import 'package:covidpass/utils/constants.dart';
import 'package:covidpass/utils/shared_pref.dart';
import 'package:covidpass/utils/user_role_serializer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Profile"),
      ),
      body: Consumer<ProfileNotifier>(
        builder: (context, notifier, child) => notifier.isRequestFinished
            ? Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          UserRoleSerializer.getEnumFromRole(
                                      SharedPrefUtils.get(
                                          Constants.USER_TYPE)) ==
                                  UserRole.MERCHANT
                              ? notifier.user.shopName
                              : "${notifier.user.firstName} ${notifier.user.lastName}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Edit Profile",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: PrimaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: TabBackgroundColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.settings),
                            title: Text("Settings"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.headset_mic),
                            title: Text("Help"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.help_outline),
                            title: Text("FAQs"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          ListTile(
                            leading: Icon(Icons.power_settings_new),
                            title: Text("Logout"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              SharedPrefUtils.setInt(Constants.USER_ID, null);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()),
                                  (route) => false);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8,
                            ),
                            child: Divider(
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            decoration: BoxDecoration(color: Colors.cyan[50]),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Practice frequent hand washing.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Wash hands with soap and water or use alcohol based hand rub.",
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Know More",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: PrimaryColor,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Image.asset(
                                  "assets/hand_wash.png",
                                  width: 84,
                                  height: 84,
                                  fit: BoxFit.cover,
                                  color: Colors.cyan[50],
                                  colorBlendMode: BlendMode.multiply,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
