import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teyake/colors.dart';
import 'package:teyake/dimensions.dart';
import 'package:teyake/pages/display.dart';
import 'package:teyake/pages/repo.dart';
import 'package:teyake/pages/save.dart';
import 'package:teyake/pages/signin.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  var Userid = const Uuid().v4();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final controller = Get.put(Repo());
  final _db = FirebaseFirestore.instance;
  final picker = ImagePicker();
  Map<String, dynamic> retrievedData = SaveData.retrieveUserData();
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

  File? _image;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        appBar: AppBar(
          title: const Text('', style: TextStyle(fontSize: 29)),

          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          centerTitle: true, // Set this to true to center the title
          elevation: 0, // Set elevation to 0 to remove the shadow
          toolbarHeight: 120, // Adjust the toolbar height as needed
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome',
                    style: TextStyle(
                        fontSize: 30.0,
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildImageDisplay(),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Icon(
                          Icons.add_a_photo,
                          color: isDarkMode ? Colors.white : Colors.black,
                          size: 40,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Profile Picture',
                        style: TextStyle(
                            fontSize: 15.0,
                            color: isDarkMode ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildnameField(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildemailField(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildphoneField(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildpasswordField(),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _showConfirmationDialog(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account?",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(() => SignIn(),
                                transition: Transition.fade),
                          text: " Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 218, 194, 14),
                            fontSize: Dimensions.font20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addItemToDatabase(BuildContext context) async {
    if (_image == null) {
      // Ensure an image is selected before adding to the database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select profile picture'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    try {
      // Check if a user with the given email or phone already exists
      final userExists = await controller.userExistsByEmailOrPhone(
          _emailController.text.trim(), _phoneController.text.trim());

      if (userExists) {
        const snackBar = SnackBar(
          content: Text(
            'User with this email or phone already exists, try logging in.',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 6),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print("User with this email or phone already exists.");
      } else {
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        SaveData.storeUserData({
          'Name': _nameController.text,
          'Phone': _phoneController.text,
          'Password': _passwordController.text,
          'Email': _emailController.text,
          'User-ID': Userid,
          'ImageURL': await _uploadImageToStorage(),
        });
        print(retrievedData['ImageURL']);
        try {
          await _db.collection("Users").add({
            'Name': _nameController.text,
            'Phone': _phoneController.text,
            'Password': _passwordController.text,
            'Email': _emailController.text,
            'User-ID': Userid,
            'ImageURL': await _uploadImageToStorage(),
          });
          Get.to(() => Display());
        } catch (e) {
          Get.snackbar('Error', 'Failed to add user. Please try again.');
        }

        Get.snackbar(
            'User Added', 'Your Account has been created successfully');

        _nameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _passwordController.clear();
      }
    } catch (e) {
      // Handle authentication error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Authentication failed. Please try again."),
      ));
    }
  }

  Future<String?> _uploadImageToStorage() async {
    final storage = FirebaseStorage.instance;
    final imageName = '${const Uuid().v4()}.jpg'; // Unique image name
    final ref = storage.ref().child('images/$imageName');
    await ref.putFile(_image!);
    return await ref.getDownloadURL();
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Widget _buildImageDisplay() {
    if (_image != null) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Set the container shape to circle
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
          // Use ClipOval for circular clipping
          child: Image.file(
            _image!,
            height: 100,
            width: 100, // Set width and height to maintain a circular shape
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return const SizedBox(); // Return an empty container when there's no image
    }
  }

  Widget _buildnameField() {
    return TextFormField(
      controller: _nameController,
      style: TextStyle(
          fontSize: 16.0, color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        hintText: 'Enter your Name',
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
        prefixIcon: const Icon(Icons.person, color: AppColors.mainColor),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your Name';
        }
        return null;
      },
    );
  }

  Widget _buildemailField() {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(
          fontSize: 16.0, color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        hintText: 'Enter your Email',
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
        prefixIcon: const Icon(Icons.email, color: AppColors.mainColor),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your Email';
        }
        return null;
      },
    );
  }

  Widget _buildphoneField() {
    return TextFormField(
      controller: _phoneController,
      style: TextStyle(
          fontSize: 16.0, color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        hintText: 'Enter your Phone Number',
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
        prefixIcon: const Icon(Icons.phone, color: AppColors.mainColor),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your Phone Number';
        }
        return null;
      },
    );
  }

  Widget _buildpasswordField() {
    return TextFormField(
      controller: _passwordController,
      style: TextStyle(
          fontSize: 16.0, color: isDarkMode ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        hintText: 'Enter your Password',
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
        prefixIcon: const Icon(Icons.password, color: AppColors.mainColor),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter your Password';
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
          content: const Text('Are you sure you want Create your account'),
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
