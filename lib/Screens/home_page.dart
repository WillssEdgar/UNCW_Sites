import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc315_team_edgar_burgess_project/Screens/details_screen.dart';
import 'package:csc315_team_edgar_burgess_project/site_class.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ListOfSites extends StatefulWidget {
  const ListOfSites({super.key});

  @override
  State<ListOfSites> createState() => _ListOfSitesState();
}

class _ListOfSitesState extends State<ListOfSites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hawks Eye"),
        backgroundColor: Colors.teal,
      ),
      body: const SitesList(),
    );
  }
}

class SitesList extends StatefulWidget {
  const SitesList({super.key});

  @override
  State<SitesList> createState() {
    return _SitesListState();
  }
}

class _SitesListState extends State<SitesList> {
  final sitesRef = FirebaseFirestore.instance.collection('Sites');

  late String userID;

  List<String> favorites = [];

  Future<void> _populateFavorites() async {
    try {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();

      // Check if the user document exists
      if (userSnapshot.exists) {
        // Retrieve the array field 'arrayField' from the user document
        List<dynamic> arrayField = userSnapshot.data()!['favorites'];

        // Clear the existing favorites list before populating
        setState(() {
          favorites.clear();
        });

        // Add each element of the arrayField to the favorites list
        for (var element in arrayField) {
          setState(() {
            favorites.add(element);
          });
        }
      } else {
        // User document with userID doesn't exist
        print('User document not found');
      }
    } catch (e) {
      // Error occurred during fetching data
      print('Error fetching user document: $e');
    }
  }

  Future<String?> getImageUrl(String imageId) async {
    try {
      // Reference to the image in Firebase Storage
      Reference imageRef =
          FirebaseStorage.instance.ref().child('site_pictures/$imageId');

      // Get the download URL for the image
      String imageUrl = await imageRef.getDownloadURL();

      // Return the image URL
      return imageUrl;
    } catch (e) {
      // Handle errors, such as if the image doesn't exist
      Text('Error getting image URL: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    userID = FirebaseAuth.instance.currentUser?.uid ?? '';
    _populateFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: sitesRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching data"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No sites available"));
          }

          var docs = snapshot.data!.docs;

          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                var doc = docs[index];
                var site = Site.fromFirestore(doc);

                return Card(
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        title: Text(site.name),
                        leading: const Icon(
                          Icons.location_on,
                          color: Colors.teal,
                        ),
                        trailing: Wrap(
                          children: [
                            IconButton(
                              icon: Icon(
                                // _favoriteSites[site.name] ?? false
                                favorites.contains(site.name)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                setState(() {
                                  if (favorites.contains(site.name)) {
                                    favorites.remove(site.name);
                                  } else {
                                    favorites.add(site.name);
                                  }
                                });

                                // Update favorites in Firestore
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userID)
                                    .update({'favorites': favorites}).then((_) {
                                  print('Favorites updated successfully');
                                }).catchError((error) {
                                  print('Failed to update favorites: $error');
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailScreen(
                                      site: site,
                                      value: favorites.contains(site.name)),
                                ));
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        child: FutureBuilder<String?>(
                          future: getImageUrl(site.image),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error: ${snapshot.error}"));
                            }
                            if (!snapshot.hasData || snapshot.data == null) {
                              return const Center(
                                  child: Text("No image available"));
                            }
                            return Image.network(snapshot.data!);
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }
}
