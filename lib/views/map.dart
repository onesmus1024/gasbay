import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class GetLocation extends StatefulWidget {
  GetLocation({Key? key, required this.latlong}) : super(key: key);
  List<double> latlong;
  static const String routeName = '/getLocation';
  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-1.286389,  36.817223),
    zoom: 5.4746,
  );

   late CameraPosition _kLake; 

  late Marker destinationMarker;

  static final Marker myMarker = Marker(
    markerId: const MarkerId('myMarker'),
    position: const LatLng(-1.286389,  36.817223),
    infoWindow: const InfoWindow(title: 'Hello'),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueViolet,
    ),
  );
  late Polyline polyline;
  void setMarkerPolylin(List<double> latlong) {
    setState(() {
      destinationMarker = Marker(
        markerId: const MarkerId('marker'),
        position: LatLng(latlong[0], latlong[1]),
        infoWindow: const InfoWindow(title: 'Hello'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        ),
      );
      polyline = Polyline(
        polylineId: const PolylineId('mypoly'),
        visible: true,
        points: <LatLng>[
          const LatLng(-1.286389,  36.817223),
          LatLng(latlong[0], latlong[1]),
        ],
        width: 10,
        color: Colors.red,
        startCap: Cap.roundCap,
        endCap: Cap.buttCap,
        jointType: JointType.bevel,
      );
      _kLake= CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(latlong[0], latlong[1]),
      tilt: 59.440717697143555,
      zoom: 10.15);
    });
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  @override
  Widget build(BuildContext context) {
    List<double> latlong = widget.latlong;
    setMarkerPolylin(latlong);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gasbay User Destination'),
        backgroundColor: Colors.teal,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: {
          destinationMarker,
          myMarker,
        },
        polylines: {
          polyline,
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('Take me user to destination!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }
}
