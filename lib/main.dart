//import 'package:csc315_team_edgar_burgess_project/Screens/home.dart';
import 'package:csc315_team_edgar_burgess_project/Screens/first_screen.dart';
import 'package:csc315_team_edgar_burgess_project/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MaterialApp(title: "Hawk Eye", home: MainApp()));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool firebaseReady = false;
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).then((value) => setState(() => firebaseReady = true));
  }

  @override
  Widget build(BuildContext context) {
    if (!firebaseReady) return const Center(child: CircularProgressIndicator());

    // currentUser will be null if no one is signed in.
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) return const HomeScreen();
    return const FirstScreen();
  }
}


// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Hawks Eye',
//       home: LoginScreen(),
//     );
//   }
// }
