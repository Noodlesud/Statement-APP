import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teyake/pages/repo.dart';
import 'package:teyake/pages/save.dart';
import 'package:teyake/pages/side_bar.dart';
import 'package:teyake/pages/signin.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> retrievedData = SaveData.retrieveUserData();
  final controller = Get.put(Repo());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  File? _image;
  bool isDarkMode = false; // Track theme mode

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  // Load the saved theme preference from SharedPreferences
  _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode =
          prefs.getBool('isDarkMode') ?? false; // Default to false if not set
    });
  }

  // Save the theme preference to SharedPreferences
  _saveThemePreference(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDark);
  }

  @override
  Widget build(BuildContext context) {
    // General settings
    String capitalize(String s) =>
        s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

    Sidebar();

    final List<Map<String, dynamic>> general = [
      {
        "title": "Subscription Plans".tr,
        "leadingIcon": Icons.subscriptions_outlined,
        "onTap": () {
          // Uncomment and implement navigation
        },
        "trailing": Icon(Icons.chevron_right_outlined,
            color: isDarkMode ? Colors.white : Colors.black),
      },
      {
        "title": "Change Theme",
        "leadingIcon": isDarkMode
            ? Icons.light_mode
            : Icons.dark_mode, // Update icon based on current theme
        "onTap": () {
          setState(() {
            isDarkMode = !isDarkMode;
            _saveThemePreference(isDarkMode);
          });
          // Restart the app to apply the theme change
        },
        "trailing": const SizedBox(),
      },
    ];

    // Other settings list (unchanged)
    final List<Map<String, dynamic>> other = [
      {
        "title": "Privacy Policy".tr,
        "leadingIcon": Icons.privacy_tip_outlined,
        "onTap": () {
          // Navigation code for Privacy Policy
        },
        "trailing": Icon(Icons.chevron_right_outlined,
            color: isDarkMode ? Colors.white : Colors.black),
      },
      {
        "title": "FAQ".tr,
        "leadingIcon": Icons.question_mark,
        "onTap": () {
          // Navigation code for FAQ
        },
        "trailing": Icon(Icons.chevron_right_outlined,
            color: isDarkMode ? Colors.white : Colors.black),
      },
      {
        "title": "Terms and Conditions",
        "leadingIcon": Icons.error,
        "onTap": () {
          // Navigation code for Terms and Conditions
        },
        "trailing": Icon(Icons.chevron_right_outlined,
            color: isDarkMode ? Colors.white : Colors.black),
      },
      {
        "title": "About",
        "leadingIcon": Icons.info_outline_rounded,
        "onTap": () {
          // Navigation code for About
        },
        "trailing": Icon(Icons.chevron_right_outlined,
            color: isDarkMode ? Colors.white : Colors.black),
      },
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDarkMode
          ? Colors.black
          : Colors.white, // Change background color based on theme
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.menu,
              color: isDarkMode
                  ? Colors.white
                  : Colors.black), // Adjust icon color based on theme
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode, // Toggle theme icon
              color: isDarkMode
                  ? Colors.white
                  : Colors.black, // Adjust icon color based on theme
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
                _saveThemePreference(isDarkMode);
              });
              // Restart the app to apply the theme change
            },
          ),
        ],
      ),
      drawer: Sidebar(),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black, // Change text color based on theme
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          capitalize(retrievedData['Name'].toString() ?? "N/A"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.white
                                : Colors
                                    .black, // Adjust text color based on theme
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // General settings list with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSettingsList(general),
            ),
            // Divider with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(height: 30, thickness: 1),
            ),
            // Other settings list with padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildSettingsList(other),
            ),
            // Logout option styled as a ListTile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.red[300]),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.red[300],
                      fontWeight: FontWeight.w500),
                ),
                onTap: () async {
                  SaveData.clearUserData();

                  Get.offAll(() => SignIn());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build the settings list
  Widget _buildSettingsList(List<Map<String, dynamic>> settings) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: settings.length,
      itemBuilder: (context, index) {
        final setting = settings[index];
        return Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16.0), // Adjust horizontal padding
            leading: Icon(setting['leadingIcon'],
                color: isDarkMode
                    ? Colors.white
                    : Colors.black), // Change icon color based on theme
            title: Text(
              setting['title'],
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: isDarkMode
                      ? Colors.white
                      : Colors.black), // Change text color based on theme
            ),
            onTap: setting['onTap'],
            trailing: setting['trailing'],
          ),
        );
      },
    );
  }
}
