import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';
import 'package:weather_app/widget/weather_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherServices _weatherServices = WeatherServices();
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  Weather? _weather;

  void _getWeather() async {
    setState(() {
      _isLoading = true;
    });

    try{
      final weather = await _weatherServices.fetchWeather(_controller.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error found')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: _weather != null && _weather!.description.toLowerCase().contains('rain') ?
          LinearGradient(colors:[Colors.grey,Colors.blueGrey],
          begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
             : _weather != null && _weather!.description.toLowerCase().contains('clear') ?
          LinearGradient(colors:[Colors.orangeAccent,Colors.blueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
              : LinearGradient(colors:[Colors.grey,Colors.lightBlueAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(height: 30,),
                Text('WEATHER APP',style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFFFFFF),
                ),),
                SizedBox(height: 25,),

                TextField(
                  controller: _controller,
                  cursorColor: Color(0xff000000),
                  cursorHeight: 20,
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                  ),
                    decoration: InputDecoration(
                        hintText: 'Enter City Name',
                        helperStyle: TextStyle(
                          color: Colors.white70,
                        ),
                        filled: true,
                      fillColor: Colors.white38,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30)
                      )
                    )
                ),

                SizedBox(height: 20,),
                ElevatedButton(
                    onPressed: _getWeather,
                    child: Text('Get Weather',style: TextStyle(
                    fontSize: 18,
                      color: Color(0xffFFFFFF)
                ),
                    ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black26,
                    foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                  ),
                ),
                if (_isLoading)
                  Padding(padding: EdgeInsets.all(28),
                  child: CircularProgressIndicator(
                    color: Color(0xffFFFFFF),
                  ),
                  ),
                if (_weather != null)
                  WeatherCard(weather: _weather!)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
