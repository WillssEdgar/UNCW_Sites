import 'package:csc315_team_edgar_burgess_project/Screens/first_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("This app was created by Wills Edgar and Anna Burgess"),
            ElevatedButton(
              onPressed: () {
                // signOut() doesn't return anything, so we don't need to await
                // for it to finish unless we really want to.
                FirebaseAuth.instance.signOut();

                // This navigator call clears the Navigation stack and takes
                // them to the login screen because we don't want users
                // "going back" in our app after they log out.
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const FirstScreen()),
                    (route) => false);
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
