import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc315_team_edgar_burgess_project/Screens/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? password;
  String? confirmPassword;
  String? error;
  final _formKey = GlobalKey<FormState>();

  Future<void> addUserToFirestore(String firstName, String lastName,
      String email, String username, String userID) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userID);

    // Create or update the user document with basic info
    await userRef.set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'userID': userID,
      'favorites': [],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/tripple_seahawk.png', // Provide the path to your background image
                fit: BoxFit.cover, // Adjust the fit property as needed
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 110, 55, 110),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey
                          .withOpacity(0.5), // Adjust opacity of the blue color
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 100, 40, 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 75,
                            ),
                            TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Enter your First Name'),
                                onChanged: (value) => firstName = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null; // Returning null means "no issues"
                                }),
                            TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Enter your Last Name'),
                                onChanged: (value) => lastName = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null; // Returning null means "no issues"
                                }),
                            TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Enter your email'),
                                maxLength: 64,
                                onChanged: (value) => email = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null; // Returning null means "no issues"
                                }),
                            TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Enter your username'),
                                maxLength: 15,
                                onChanged: (value) => username = value,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null; // Returning null means "no issues"
                                }),
                            TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "Enter a password"),
                                obscureText: true,
                                onChanged: (value) => password = value,
                                validator: (value) {
                                  if (value == null || value.length < 8) {
                                    return 'Your password must contain at least 8 characters.';
                                  }
                                  return null; // Returning null means "no issues"
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "Confirm your password"),
                                obscureText: true,
                                onChanged: (value) => confirmPassword = value,
                                validator: (value) {
                                  if (password != value) {
                                    return 'Passwords must match.';
                                  }
                                  return null; // Returning null means "no issues"
                                }),
                            const SizedBox(height: 16),
                            ElevatedButton(
                                style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(5),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(300, 40)),
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.teal, fontSize: 20),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    trySignUp();
                                  }
                                }),
                            if (error != null)
                              Text(
                                "Error: $error",
                                style: TextStyle(
                                    color: Colors.red[800], fontSize: 12),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void trySignUp() async {
    try {
      // The await keyword blocks execution to wait for
      // signInWithEmailAndPassword to complete its asynchronous execution and
      // return a result.
      //
      // FirebaseAuth with raise an exception if the email or password
      // are determined to be invalid, e.g., the email doesn't exist.
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      error = null; // clear the error message if exists.
      setState(() {}); // Trigger a rebuild

      // We need this next check to use the Navigator in an async method.
      // It basically makes sure LoginScreen is still visible.
      if (!mounted) return;

      addUserToFirestore(firstName!, lastName!, email!, username!,
          FirebaseAuth.instance.currentUser!.uid);

      // pop the navigation stack so people cannot "go back" to the login screen
      // after logging in.
      Navigator.of(context).pop();
      // Now go to the HomeScreen.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ));
    } on FirebaseAuthException catch (e) {
      // Exceptions are raised if the Firebase Auth service
      // encounters an error. We need to display these to the user.
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      } else {
        error = 'An error occurred: ${e.message}';
      }

      // Call setState to redraw the widget, which will display
      // the updated error text.
      setState(() {});
    }
  }
}
