import 'package:flutter/material.dart';
import 'package:teyake/colors.dart';
import 'package:teyake/pages/display.dart';
import 'package:teyake/pages/save.dart';
import 'package:teyake/pages/side_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _db = FirebaseFirestore.instance;
  var questionid = const Uuid().v4();
  // Track theme mode

  Map<String, dynamic> retrievedData = SaveData.retrieveUserData();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDarkMode = false;
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
    return Container(
      child: Scaffold(
          key: _scaffoldKey, // Assign the key to the Scaffold

          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          appBar: AppBar(
            title: Text(
              'Enter Your Entries',
              style: TextStyle(
                color: isDarkMode
                    ? Colors.white
                    : Colors.black, // Change text color based on theme
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            leading: IconButton(
              color: isDarkMode ? Colors.white : Colors.black,
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Open the sidebar using the GlobalKey
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          drawer: Sidebar(),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(children: [
                  const SizedBox(
                    height: 40,
                  ),
                  _buildquestionField(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.only(top: 20),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _showConfirmationDialog(context);
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Colors.green[800],
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Add Entry',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      const SizedBox(height: 10),
                    ],
                  ),
                ]),
              ),
            ),
          )),
    );
  }

  Future<void> _addItemToDatabase(BuildContext context) async {
    try {
      await _db.collection("questions").add({
        'Question': _questionController.text,
        "User-ID": retrievedData['User-ID'],
        'Question-ID': questionid,
        'Like': "0",
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to Add Store. Please try again.');
    }

    Get.snackbar(
      'Question Added',
      'Your question has been Added successfully',
      backgroundColor: Colors.green,
    );
    FocusScope.of(context).unfocus();
    _questionController.clear();

    questionid = const Uuid().v4();
  }

  Widget _buildquestionField() {
    return TextFormField(
      controller: _questionController,
      style: TextStyle(
        fontSize: 16.0,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: 'Entry',
        hintText: 'Enter your Entry',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.mainColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: AppColors.mainColor, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        prefixIcon: const Icon(Icons.question_mark, color: AppColors.mainColor),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your entry';
        }
        return null;
      },
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to add this Entry'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Close the dialog and pass false
              },
              child: const Text(
                'No',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Close the dialog and pass true
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        _addItemToDatabase(context);
      }
    });
  }
}
