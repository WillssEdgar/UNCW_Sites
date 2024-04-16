import 'dart:ui'; // Import this for ImageFilter
import 'package:flutter/material.dart';
import 'package:csc315_team_edgar_burgess_project/Screens/login_screen.dart';
import 'package:csc315_team_edgar_burgess_project/Screens/sign_up_screen.dart';
import 'package:flutter/widgets.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // Use a Stack to overlay the background image
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/seahawk.png', // Provide the path to your background image
              fit: BoxFit.cover,
              // Adjust the fit property as needed
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 200, 40, 200),
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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(55),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: const Text(
                            "Welcome to Hawks Eye",
                            style: TextStyle(fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(200, 40)),
                              ),
                              child: const Text(
                                "Login",
                                style:
                                    TextStyle(color: Colors.teal, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ));
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all(5),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(200, 40)),
                              ),
                              child: const Text(
                                "Sign Up",
                                style:
                                    TextStyle(color: Colors.teal, fontSize: 20),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
