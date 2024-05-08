import 'package:csc315_team_edgar_burgess_project/site_class.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Site site;
  final bool value;

  const DetailScreen({super.key, required this.site, required this.value});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Hawks Eye',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            Icon(
              value ? Icons.favorite : Icons.favorite_border,
            ),
            const SizedBox(
              width: 10,
            )
          ],
          backgroundColor: Colors.teal[200],
          centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text((site.name),
                    style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 36,
                        fontWeight: FontWeight.bold))),
            FutureBuilder<String?>(
              future: getImageUrl(site.image),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text("No image available"));
                }
                return Image.network(snapshot.data!);
              },
            ),
            Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  'About ${site.name}:',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w900),
                )),
            Padding(
              padding:
                  const EdgeInsets.only(left: 60.0, right: 60.0, bottom: 30.0),
              child: Text('\u2022 ${site.description}',
                  style: const TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}
