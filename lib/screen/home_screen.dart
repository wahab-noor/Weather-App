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
                Text('Weather App',style:TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFFFFFF),
                    fontSize: 30
                ),),
                SizedBox(height: 20,),
                if (_weather != null)
                  WeatherCard(weather: _weather!),
                SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controller,
                    cursorColor: Color(0xff18181B),
                    cursorHeight: 20,
                    style: TextStyle(
                      color: Color(0xff18181B),
                    ),
                      decoration: InputDecoration(
                          hintText: 'City Name',
                          helperStyle: TextStyle(
                            color: Color(0xffE5E7EB),
                          ),
                          filled: true,
                        fillColor: Color(0xffE5E7EB),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)
                        )
                      )
                  ),
                ),

                SizedBox(height: 15,),
                ElevatedButton(
                    onPressed: _getWeather,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black26,
                    foregroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      )
                  ),
                    child: Text('Get Weather',style: TextStyle(
                    fontSize: 18,
                      color: Color(0xffFFFFFF)
                ),
                    ),
                ),
                if (_isLoading)
                  Padding(padding: EdgeInsets.all(28),
                  child: CircularProgressIndicator(
                    color: Color(0xffFFFFFF),
                  ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
