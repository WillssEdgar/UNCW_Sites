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
                  Icons.more_vert,
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

  const _DetailScreen({Key? key, required this.site}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail View"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(" Site Name: ${site.name}"),
            Image.asset(site.image),
            Text(site.description)
          ],
        ),
      ),
    );
  }
}
