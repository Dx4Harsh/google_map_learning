import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_map_learning/provider/map_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(30.861694, 75.895169),
    zoom: 15.0,
  );
  
  final TextEditingController locController = TextEditingController();

  List<Marker> marker = [];
  List<Marker> list = const [
    Marker(
      markerId: MarkerId('1'),
      position:  LatLng(30.861694, 75.895169),
      infoWindow: InfoWindow(
        title: "My current Location",
      ),

    ),
    Marker(
      markerId: MarkerId('2'),
      position:  LatLng(30.860190, 75.895061),
      infoWindow: InfoWindow(
        title: "Location",
      ),
    ),
  ];

  @override
  void initState() {
    marker.addAll(list);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            mapType: MapType.hybrid,
            initialCameraPosition: _initialPosition,
            myLocationEnabled: true,
            markers: Set.of(marker),
          ),

          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextFormField(
                      controller: locController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.location_on_sharp, color: Colors.red),
                        hintText: "Location",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async{
                        String loc = locController.text.trim();
                        await context.read<MapProvider>().searchLocation(loc);
                        final searchedLoc = context.read<MapProvider>().searchedLocation;
                        if (searchedLoc != null) {
                          GoogleMapController controller = await _controller.future;
                          controller.animateCamera(CameraUpdate.newCameraPosition(
                            CameraPosition(target: searchedLoc, zoom: 14),
                          ));
                        }

                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(30.861694, 75.895169),
          zoom: 14),
        ));
      },child: Icon(Icons.location_on),),
    );
  }
}
