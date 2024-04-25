import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc315_team_edgar_burgess_project/Screens/details_screen.dart';
import 'package:csc315_team_edgar_burgess_project/Screens/first_screen.dart';
import 'package:csc315_team_edgar_burgess_project/site_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final sitesRef = FirebaseFirestore.instance.collection('Sites');
  final userRef = FirebaseFirestore.instance.collection('users');
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to your Profile!'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.teal,
        actions: [
          ElevatedButton(
            onPressed: () {
              // signOut() doesn't return anything, so we don't need to await
              // for it to finish unless we really want to.
              FirebaseAuth.instance.signOut();

              // This navigator call clears the Navigation stack and takes
              // them to the login screen because we don't want users
              // "going back" in our app after they log out.
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const FirstScreen()),
                  (route) => false);
            },
            child: const Text("Logout"),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content above the GridView
          StreamBuilder<QuerySnapshot>(
            stream: userRef.where('userID', isEqualTo: userID).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No profile"));
              }
              var userData =
                  snapshot.data!.docs.first.data() as Map<String, dynamic>;

              return Padding(
                  padding: EdgeInsets.all(30),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.account_circle,
                        size: 70,
                      ),
                      Column(
                        children: [
                          Text(
                            userData['firstName'] + " " + userData['lastName'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text("@${userData['username']}"),
                        ],
                      )
                    ],
                  ));
            },
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: sitesRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No sites available"));
                }

                var docs = snapshot.data!.docs;

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var doc = docs[index];
                    var site = Site.fromFirestore(doc);
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                        site: site,
                                        value: true,
                                      )));
                        },
                        child: Card(
                          elevation: 3,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 65,
                                child: ListTile(
                                  tileColor: Colors.white,
                                  title: Text(site.name),
                                  leading: const Icon(
                                    Icons.location_on,
                                    color: Colors.teal,
                                  ),
                                ),
                              ),
                              Container(
                                width: 300,
                                height: 172,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                  child: Image.asset(
                                    site.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

      // const Text("This app was created by Wills Edgar and Anna Burgess"),
      // ElevatedButton(
      //   onPressed: () {
      //     // signOut() doesn't return anything, so we don't need to await
      //     // for it to finish unless we really want to.
      //     FirebaseAuth.instance.signOut();

      //     // This navigator call clears the Navigation stack and takes
      //     // them to the login screen because we don't want users
      //     // "going back" in our app after they log out.
      //     Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(builder: (context) => const FirstScreen()),
      //         (route) => false);
      //   },
      //   child: const Text("Logout"),
      // )
