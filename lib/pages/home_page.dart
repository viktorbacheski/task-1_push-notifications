import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomePasge extends StatefulWidget {
  const HomePasge({super.key});

  @override
  State<HomePasge> createState() => _HomePasgeState();
}

class _HomePasgeState extends State<HomePasge> {
  String locationMessage = 'Current Location of the User';
  late String lat;
  late String long;
  Position? currentPossitionOfUser;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void>_getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location premissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location premissions are premanently denied, we cannot request premission');
    }
    
    _liveLocation();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 500,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
      .listen((Position position) async {
        lat = position.latitude.toString();
        long = position.longitude.toString();

        setState(() {
          locationMessage = 'Latitude: $lat , Longitude : $long';
        });
        await _sendYourLocationToServer(position.latitude, position.longitude);
      });
  }

  Future<void> _sendYourLocationToServer(double lat, double long) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final callable = FirebaseFunctions.instance.httpsCallable('updateUserPosition');
    await callable.call(<String, dynamic>{
      'latitude': lat,
      'longitude': long,
      'fcmToken': fcmToken
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            Text(locationMessage, textAlign: TextAlign.center),       
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}