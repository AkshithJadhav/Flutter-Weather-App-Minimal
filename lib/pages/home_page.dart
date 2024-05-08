import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app_minimal/models/weather_model.dart';
import 'package:weather_app_minimal/service/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //api key
  final _weatherService = WeatherService('6061eb8d09fb759a26cf0f5504a77204');

  Weather? _weather;

  //fetch weather
  _fetchWeather()async{
    //get current city
    String cityName = await _weatherService.getCurrentCity();
    //get weather for this city
    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      print(e);
    }
  }

  //weather animation
  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) return 'assets/sunny.json';
    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/clouds.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }
  //init state
  @override
  void initState() {
    super.initState();
    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //city name
               Column(
                children: [
                  const Icon(Icons.location_on),
                  const SizedBox(height: 10,),
                  Text(_weather?.cityName?? "Loading City",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade400,
                  ),
                ),
                ],
              ),
            //animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition ?? "")),
            //temparature
            Column(
              children: [
                Text('${_weather?.temparature.round()}° C',
                 style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3,),
                 //weather condition
                Text(_weather?.mainCondition ?? "",style: TextStyle(color: Colors.grey.shade400,)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}