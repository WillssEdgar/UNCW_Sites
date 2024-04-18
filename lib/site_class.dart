import 'package:cloud_firestore/cloud_firestore.dart';

class Site {
  final String name;
  final String description;
  final String image;
  final bool favorite;

  const Site({
    required this.name,
    required this.description,
    required this.image,
    required this.favorite,
  });

  factory Site.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool favorite = false;
    if (data.containsKey('favorite') && data['favorite'] is bool) {
      favorite = data['favorite'];
    }

    return Site(
        name: data['name'],
        description: data['description'],
        image: data['image'],
        favorite: favorite);
  }
}
