import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  bool isLoading = true;
  bool isError = false;
  String location = '';
  String temperature = '';
  String weatherDescription = '';
  String iconUrl = '';

  @override
  void initState() {
    super.initState();
    getLocationWeather();
  }

  Future<void> getLocationWeather() async {
    try {
      final apiKey = 'YOUR_API_KEY';
      final url = 'https://api.openweathermap.org/data/2.5/weather?q={Dhaka}&appid=76378c0f9f43ca413805008be75843f5';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          location = data['name'];
          temperature = (data['main']['temp'] - 273.15).toStringAsFixed(1);
          weatherDescription = data['weather'][0]['description'];
          iconUrl = 'https://openweathermap.org/img/w/${data['weather'][0]['icon']}.png';
          isLoading = false;
          isError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator() // Show loading indicator while fetching data
              : isError
              ? Text('Error fetching weather data.') // Show error message if there is a problem
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                location,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 16),
              Image.network(iconUrl),
              SizedBox(height: 16),
              Text(
                '$temperature°C',
                style: TextStyle(fontSize: 32),
              ),
              SizedBox(height: 16),
              Text(
                weatherDescription,
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
