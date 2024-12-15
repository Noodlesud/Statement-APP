import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teyake/colors.dart';
import 'package:teyake/pages/account.dart';
import 'package:teyake/pages/add_item.dart';
import 'package:teyake/pages/display.dart';
import 'package:teyake/pages/save.dart';
import 'package:get/get.dart';

File? _image;

class Sidebar extends StatefulWidget {
  Sidebar({super.key});

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  Map<String, dynamic> retrievedData = SaveData.retrieveUserData();
  bool isDarkMode = false;

  // Load the theme preference from SharedPreferences
  _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode =
          prefs.getBool('isDarkMode') ?? false; // Default to false if not set
    });
  }

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          // Apply a gradient to the entire sidebar based on dark mode
          gradient: isDarkMode
              ? LinearGradient(
                  colors: [Colors.black, Colors.grey],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [Colors.blueGrey.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Drarwer Header with updated design
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black87 : Colors.grey,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User's profile image
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: ClipOval(
                      child: Image.network(
                        retrievedData['ImageURL'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // User's name and email
                  Text(
                    retrievedData["Name"],
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    retrievedData["Email"],
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            // Home ListTile with updated styling
            ListTile(
              title: Text(
                'Home',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => Display());
              },
            ),
            // Add Entry ListTile with updated styling
            ListTile(
              title: Text(
                'Add Entry',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => AddItem());
              },
            ),
            // Setting ListTile with updated styling
            ListTile(
              title: Text(
                'Setting',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.to(() => ProfileScreen());
              },
            ),
            // Add more ListTiles for additional menu items here
          ],
        ),
      ),
    );
  }
}
