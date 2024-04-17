import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc315_team_edgar_burgess_project/site_class.dart';
import 'package:flutter/material.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: SitesList());
  }
}

class _DetailScreen extends StatelessWidget {
  final Site site;

  const _DetailScreen({required this.site});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Hawks Eye',
            style: TextStyle(color: Colors.black),
          ),
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
            Image.asset(site.image),
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

class SitesList extends StatelessWidget {
  SitesList({super.key});

  final sitesRef = FirebaseFirestore.instance.collection('Sites');

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
                    child: ListTile(
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
                            site.favorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.teal),
                        onPressed: () {
                          doc.reference.update({'favorite': !site.favorite});
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => _DetailScreen(site: site)));
                        },
                      ),
                    ],
                  ),
                ));
              });
        });
  }
}
