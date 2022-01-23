import 'dart:async';
import 'package:em6330_cw2_2168794_prashanth/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocation/geolocation.dart';
import 'package:em6330_cw2_2168794_prashanth/services/location.dart';
import 'package:em6330_cw2_2168794_prashanth/screens/location_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  void getGeoLocation() async{
    final GeolocationResult result = await Geolocation.requestLocationPermission(
      permission: const LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );

    if(result.isSuccessful) {
      // location permission is granted (or was already granted before making the request)
      StreamSubscription<LocationResult> subscription = Geolocation.currentLocation(accuracy: LocationAccuracy.best).listen((result) async {
        if(result.isSuccessful) {
          var apiKey = '74b4090569c606e90bf66605a363f306';
          CurrentLocation location = new CurrentLocation(result.location.longitude, result.location.latitude);
          var network = NetworkHelper("?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric");
          var weather = await network.getData();
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return LocationScreen(locationWeather: weather);
          }));
        }
      });
    } else {
      // location permission is not granted
      // user might have denied, but it's also possible that location service is not enabled, restricted, and user never saw the permission request dialog. Check the result.error.type for details.
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGeoLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: Colors.lightBlue,
          size: 100.0,
        ),
      ),
    );
  }
}
