import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  String? locationDescription;
  MapController mapController = MapController();
  List<Marker> markers = [];
  String? imageFile;
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';
  late LatLng location;

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

  void _submitbutton() async {
    CollectionReference sitesRef =
        FirebaseFirestore.instance.collection('Sites');
    CollectionReference userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('Sites');
    try {
      if (imageFile != null) {
        // Upload the image file.
        File image = File(imageFile!);
        String fileName = image.path.split('/').last;
        Reference storageReference =
            FirebaseStorage.instance.ref().child('site_pictures/$fileName');
        UploadTask uploadTask = storageReference.putFile(image);
        await uploadTask.whenComplete(() => null);

        sitesRef.add({
          'description': locationDescription,
          'location': GeoPoint(location.latitude, location.longitude),
          'image': fileName,
          'name': locationName,
        });
        userRef.add({
          'site_name': locationName,
          'location': GeoPoint(location.latitude, location.longitude),
          'location_description': locationDescription,
          'image': fileName,
        });

        setState(() {
          // Reset form fields
          locationName = null;
          locationDescription = null;
          imageFile = null;

          // Clear markers
          markers.clear();

          // Reset map controller
          mapController.move(const LatLng(0, 0), 0);

          // Reset showMap flag
          showMap = false;
        });
      } else {
        // If imageFile is null, display an error message or handle it accordingly
        print("Please select an image before submitting.");
      }
    } catch (err) {
      // Handle any errors that occur during the upload process
      print("Failed to upload image: $err");
    }
  }

  _getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        imageFile = pickedImage.path;
      });
    }
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
                            location = point;
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
                  SizedBox(
                    height: 70,
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1)),
                          labelText: 'Please Give the Location a Description.',
                          hintText: 'Example: It is a beautiful Place.'),
                      onChanged: (value) => locationDescription = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null; // Returning null means "no issues"
                      },
                    ),
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
                      child: Image.file(File(imageFile!), width: 250),
                    ),
                  },
                  Column(
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(125, 40)),
                          elevation: MaterialStateProperty.all<double?>(3),
                        ),
                        onPressed: () {
                          _submitbutton();
                        },
                        child: const Text(
                          "Submit Site",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
