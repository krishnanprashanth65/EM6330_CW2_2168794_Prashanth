import 'package:em6330_cw2_2168794_prashanth/services/weatherData.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

class NetworkHelper {
  NetworkHelper(this.url);
  final String url;
  String openWeatherMap = "http://api.openweathermap.org/data/2.5/weather";

  Future<WeatherData> getData() async {

    WeatherData weather = WeatherData();

    var url = Uri.parse('$openWeatherMap${this.url}');

    Response response = await http.get(url);
    String data = response.body;
    var decodedData = jsonDecode(data);

    double temperature = decodedData['main']['temp'];
    int condition = decodedData['weather'][0]['id'];
    String cityName = decodedData['name'];

    weather.temperature = temperature;
    weather.cityName = cityName;
    weather.condition = condition;

    return weather;
  }

  Future<WeatherData> getLocationDataByName(String location) async {
    WeatherData weather = WeatherData();


    var apiKey = '74b4090569c606e90bf66605a363f306';
    var url = Uri.parse('$openWeatherMap${this.url}');
    Response response = await get(url);
    print(response.statusCode);
    if(response.statusCode == 200){


      String data = response.body;
      var decodedData = jsonDecode(data);
      double temperature = decodedData['main']['temp'];
      int condition = decodedData['weather'][0]['id'];
      String cityName = decodedData['name'];

      weather.temperature = temperature;
      weather.cityName = cityName;
      weather.condition = condition;

      print(temperature);
      print(cityName);
      print(condition);

    }else{
      print(response.statusCode);
    }

    return weather;
  }

}