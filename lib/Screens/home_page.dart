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
  late Map<String, bool> _favoriteSites = {};

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
      print('Error getting image URL: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    userID = FirebaseAuth.instance.currentUser?.uid ?? '';

    _initializeFavoriteSites();
  }

  final nameToNumber = {
    "Trask Coliseum": 1,
    "Kenan Auditorium": 2,
    "Fisher University Union": 3,
    "Congdon Hall": 4,
    "Sartarelli Hall": 5,
    "Randall Library": 6
  };

  void _initializeFavoriteSites() async {
    final favoriteSites = <String, bool>{};

    for (var siteName in nameToNumber.keys) {
      await _loadFavoriteSites(siteName, favoriteSites);
    }

    setState(() {
      _favoriteSites = favoriteSites;
    });
  }

  Future<void> _loadFavoriteSites(
      String siteName, Map<String, bool> favoriteSites) async {
    int? siteNumber = nameToNumber[siteName];

    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    Map<String, dynamic>? userData = snapshot.data() as Map<String, dynamic>?;

    bool isFavorite = false;

    if (userData != null && userData.containsKey('favoriteSites')) {
      Map<String, dynamic> userDataInfo = userData['favoriteSites'];
      isFavorite = userDataInfo[siteNumber.toString()] ?? false;
    }

    favoriteSites[siteName] = isFavorite;
  }

  Future<void> updateFavoriteMap(String nameOfSite, bool value) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userID);
    int? siteNumber;

    nameToNumber.forEach((name, number) {
      if (name == nameOfSite) {
        siteNumber = number;
      }
    });

    if (siteNumber != null) {
      await userRef.update({
        'favoriteSites.$siteNumber': value,
      });
    }
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
                                _favoriteSites[site.name] ?? false
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.teal,
                              ),
                              onPressed: () {
                                doc.reference
                                    .update({'favorite': !site.favorite});

                                updateFavoriteMap(
                                    site.name, !_favoriteSites[site.name]!);
                                _favoriteSites[site.name] =
                                    !_favoriteSites[site.name]!;
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
                                      value: _favoriteSites[site.name]!),
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
