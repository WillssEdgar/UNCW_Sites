import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc315_team_edgar_burgess_project/site_class.dart';
import 'package:flutter/material.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  List<Site> sites = SiteData().sites;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemCount: sites.length,
        itemBuilder: (context, index) {
          return Card(
            shadowColor: Colors.teal,
            child: ListTile(
              tileColor: Colors.white,
              title: Text(sites[index].name),
              leading: const Icon(
                Icons.location_on,
                color: Colors.teal,
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.teal,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => _DetailScreen(
                            site: sites[index],
                          )));
                },
              ),
            ),
          );
        },
      ),
    );
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
    return StreamBuilder(
        stream: sitesRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text("No data to show");
          }

          var sitesDoc = snapshot.data!.docs;
          return ListView.builder(
            itemCount: sitesDoc.length,
            itemBuilder: ((context, index) => Card(
                  child: ListTile(title: Text("$sitesDoc[index].get('name')")),
                )),
          );
        });
  }
}
