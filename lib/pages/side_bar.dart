import 'dart:io';

import 'package:flutter/material.dart';
import 'package:teyake/colors.dart';
import 'package:teyake/pages/account.dart';
import 'package:teyake/pages/add_item.dart';
import 'package:teyake/pages/display.dart';
import 'package:teyake/pages/save.dart';
import 'package:get/get.dart';

File? _image;

class Sidebar extends StatelessWidget {
  Map<String, dynamic> retrievedData = SaveData.retrieveUserData();

  Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adjusted the gap here
                SizedBox(
                  width: 70, // Adjust the width as needed
                  height: 70, // Adjust the height as needed
                  child: ClipOval(
                    child: Image.network(
                      retrievedData['ImageURL'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Adjusted the gap here
                Text(
                  retrievedData["Name"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                Text(
                  retrievedData["Email"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => Display());
            },
          ),
          ListTile(
            title: const Text('Add Entry'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => AddItem());
            },
          ),
          ListTile(
            title: const Text('Setting'),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => AccountPage());
            },
          ),
          // Add more ListTiles for additional menu items
        ],
      ),
    );
  }
}
