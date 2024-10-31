import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:teyake/colors.dart';
import 'package:teyake/dimensions.dart';
import 'package:teyake/pages/display.dart';
import 'package:teyake/pages/repo.dart';
import 'package:teyake/pages/save.dart';
import 'package:teyake/pages/signup.dart';
import 'package:get/get.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final controller = Get.put(Repo());
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('', style: TextStyle(fontSize: 29)),

          backgroundColor: Colors.white24,
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
                  const Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 30.0),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Sign-In to Your Account',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildemailField(),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildpasswordField(),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _addItemToDatabase(context);
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
                        'Sign In',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Do not have an Account?",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(() => SignUp(),
                                transition: Transition.fade),
                          text: " Sign Up",
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
    try {
      // Check if a user with the given email or phone already exists
      final userExists = await controller.userExistsByEmailandPassword(
          _emailController.text.trim(), _passwordController.text.trim());
      final data = await controller.data(
          _emailController.text.trim(), _passwordController.text.trim());
      if (userExists) {
        Get.to(() => Display());
        Get.snackbar(
          'Welcome Back',
          'Signing in was successfully',
          backgroundColor: Colors.lightGreen,
        );
        _emailController.clear();
        _passwordController.clear();
      } else {
        const snackBar = SnackBar(
          content: Text(
            "User with this email Password does not already exists.",
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 6),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print("User with this email Password does not already exists.");
      }
    } catch (e) {
      // Handle authentication error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Authentication failed. Please try again."),
      ));
    }
  }

  Widget _buildemailField() {
    return TextFormField(
      controller: _emailController,
      style: const TextStyle(fontSize: 16.0, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Email',
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

  Widget _buildpasswordField() {
    return TextFormField(
      controller: _passwordController,
      style: const TextStyle(fontSize: 16.0, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Password',
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
}
