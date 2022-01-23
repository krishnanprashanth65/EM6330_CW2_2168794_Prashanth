import 'dart:async';
import 'dart:convert';

import 'package:em6330_cw2_2168794_prashanth/services/location.dart';
import 'package:em6330_cw2_2168794_prashanth/services/networking.dart';
import 'package:em6330_cw2_2168794_prashanth/services/weather.dart';
import 'package:em6330_cw2_2168794_prashanth/services/weatherData.dart';
import 'package:flutter/material.dart';
import 'package:em6330_cw2_2168794_prashanth/utilities/constants.dart';
import 'package:geolocation/geolocation.dart';
import 'package:http/http.dart';

import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({required this.locationWeather});
  final WeatherData locationWeather;

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late WeatherData weather;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(WeatherData weatherObj){
    setState(() {

      if(weatherObj.cityName == null){
        weather.temperature = 0;
        weather.cityName = 'Error';
        weather.condition = 100;
        return;
      }else{
        weather = weatherObj;
      }

    });
  }



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
          updateUI(weather);
        }
      });
    } else {
      // location permission is not granted
      // user might have denied, but it's also possible that location service is not enabled, restricted, and user never saw the permission request dialog. Check the result.error.type for details.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {

                      getGeoLocation();
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(context, MaterialPageRoute(
                          builder: (context){
                            return CityScreen();
                          }));
                      print(typedName);
                      if(typedName != null){
                        var apiKey = '74b4090569c606e90bf66605a363f306';
                        var network = NetworkHelper("?q=$typedName&appid=$apiKey&units=metric");
                        var weather = await network.getData();
                        updateUI(weather);
                      }

                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${weather.temperature.toInt()}°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      WeatherModel().getWeatherIcon(weather.condition),
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "${weather.cityName}",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
