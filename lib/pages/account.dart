import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teyake/account_widget.dart';
import 'package:teyake/app_icon.dart';
import 'package:teyake/big_text.dart';
import 'package:teyake/colors.dart';
import 'package:teyake/dimensions.dart';
import 'package:teyake/pages/repo.dart';
import 'package:teyake/pages/save.dart';
import 'package:teyake/pages/side_bar.dart';
import 'package:teyake/pages/signin.dart';
import 'package:teyake/pages/signup.dart';

import 'package:get/get.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  Map<String, dynamic> retrievedData = SaveData.retrieveUserData();
  final controller = Get.put(Repo());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.white24,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Sidebar(),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: Dimensions.height30 / 8),
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Display user icon
              SizedBox(
                width: 120, // Adjust the width as needed
                height: 120, // Adjust the height as needed
                child: ClipOval(
                  child: Image.network(
                    retrievedData['ImageURL'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: Dimensions.height30 / 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display user's name
                  BigText(
                    text: retrievedData['Name'],
                    size: Dimensions.font16 + Dimensions.font16 / 8,
                    color: Colors.black,
                  ),
                  SizedBox(width: Dimensions.width10),
                ],
              ),
              SizedBox(height: Dimensions.height30 * 2),
              // Display user's phone
              AccountWidget(
                initialValue: retrievedData['Phone'],
                appIcon: AppIcon(
                  icon: Icons.phone,
                  backgroundColor: Colors.green,
                  iconColor: Colors.white,
                  iconsize: Dimensions.height10 * 2,
                  size: Dimensions.height10 * 4,
                ),
                bigText: BigText(
                  text: '${retrievedData['Phone']}',
                  size: Dimensions.font16,
                  color: Colors.black,
                ),
              ),
              // Display user's email
              AccountWidget(
                initialValue: retrievedData['Email'],
                appIcon: AppIcon(
                  icon: Icons.email_outlined,
                  backgroundColor: Colors.green,
                  iconColor: Colors.white,
                  iconsize: Dimensions.height10 * 2,
                  size: Dimensions.height10 * 4,
                ),
                bigText: BigText(
                  text: '${retrievedData['Email']}',
                  size: Dimensions.font16,
                  color: Colors.black,
                ),
              ),
              // Display user's password
              AccountWidget(
                initialValue: retrievedData['User-ID'],
                appIcon: AppIcon(
                  icon: Icons.lock_outline,
                  backgroundColor: Colors.green,
                  iconColor: Colors.white,
                  iconsize: Dimensions.height10 * 2,
                  size: Dimensions.height10 * 4,
                ),
                bigText: BigText(
                  text: 'User-ID:${retrievedData['User-ID']}',
                  size: 12,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 60),

              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () async {
                  // Show a dialog box
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout Confirmation'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              Get.to(() => SignIn());
                              SaveData.clearUserData();
                              // Navigator.of(context).pop();
                              // controller.logout(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[300],
                            ),
                            child: const Text('Logout'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius30),
                  ),
                  minimumSize: Size(
                    Dimensions.screenWidth / 4,
                    Dimensions.screenHeight / 20,
                  ),
                ),
                child: BigText(
                  text: "Logout",
                  size: Dimensions.font16 + Dimensions.font16 / 8,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
