import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

class AddSite extends StatefulWidget {
  const AddSite({super.key});

  @override
  State<AddSite> createState() => _AddSiteState();
}

class _AddSiteState extends State<AddSite> {
  String? locationName;
  MapController mapController = MapController();
  List<Marker> markers = [];
  String? imageFile;
  var storageRef = FirebaseStorage.instance.ref();
  bool showMap = false;

  void _handleTap(LatLng latlng) {
    setState(() {
      // Remove the last marker if it exists
      if (markers.isNotEmpty) {
        markers.removeLast();
      }

      // Add the new marker
      markers.add(
        Marker(
          width: 80.0,
          height: 80.0,
          point: latlng,
          child: const Icon(
            Icons.pin_drop,
            color: Colors.red,
            size: 40.0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Site"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(250, 40),
                      ),
                      elevation: MaterialStateProperty.all<double?>(3),
                    ),
                    onPressed: () {
                      showMap = showMap ? false : true;
                      setState(() {});
                    },
                    child: const Text(
                      "Pick Location",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  if (showMap) ...{
                    Container(
                      height: 400,
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: const LatLng(
                              34.2257, -77.8722), // Centered at UNCW
                          initialZoom: 15,
                          onTap: (tapPosition, point) {
                            _handleTap(point);
                            print("This is the point" + point.toString());
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                          ),
                          MarkerLayer(markers: markers)
                        ],
                      ),
                    ),
                  },
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        const Size(250, 40),
                      ),
                      elevation: MaterialStateProperty.all<double?>(3),
                    ),
                    onPressed: () {
                      print("hello");
                    },
                    child: const Text(
                      "Use Current Location",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 70,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelText: 'Please Enter the Locations Name.',
                          hintText: 'Example: Fisher Union.'),
                      maxLength: 64,
                      onChanged: (value) => locationName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null; // Returning null means "no issues"
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(125, 40),
                          ),
                          elevation: MaterialStateProperty.all<double?>(3),
                        ),
                        onPressed: () {
                          _getImage(ImageSource.gallery);
                        },
                        child: const Text(
                          "Gallery",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(125, 40)),
                          elevation: MaterialStateProperty.all<double?>(3),
                        ),
                        onPressed: () {
                          _getImage(ImageSource.camera);
                        },
                        child: const Text(
                          "Camera",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (imageFile != null) ...{
                    SizedBox(
                      height: 300,
                      width: 200,
                      child: Image.network(imageFile!, width: 250),
                    ),
                  }
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      print(image.path);

      // Goal: rename the file used for the profile picture to be the
      // logged-in user's FirebaseAuth unique ID (uid)

      // Extract the image file extension.
      String fileExtension = '';
      int period = image.path.lastIndexOf('.');
      if (period > -1) {
        fileExtension = image.path.substring(period);
      }

      // Specify the bucket location so that it will be something like
      // '<ourBucket>/profilepics/Zasow3qeh1109dhalased.jpg'
      final profileImgRef = storageRef.child(
          "site_pictures/${FirebaseAuth.instance.currentUser!.uid}$fileExtension");

      try {
        // Upload the image file.
        await profileImgRef.putFile(File(image.path));

        // Get a public URL that we can download the image from
        imageFile = await profileImgRef.getDownloadURL();
        setState(() {
          // We should provide some feedback to the user here.
          print("File saved successfully!");
        });
      } on FirebaseException catch (err) {
        // Caught an exception from Firebase because I'm not on the net,
        // or I don't have permission
        print("Failed with error ${err.code}: ${err.message}");
      }
    }
  }
}
