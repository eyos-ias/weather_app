import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/data_service.dart';
import 'package:weather_app/response_example.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _cityTextController = TextEditingController();
  final _dataService = DataService();
  //late WeatherResponse _response;
  late String sityName = '';
  late int temperature = 0;
  late bool searching = false;
  late String description = '';
  late bool wrong = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            wrong
                ? Text('something went wrong')
                : searching
                    ? SpinKitDoubleBounce(
                        color: Colors.blueAccent,
                        size: 100.0,
                      )
                    : Column(
                        children: [
                          Text(sityName),
                          Text(
                            '${temperature.toString()}°',
                            style: TextStyle(fontSize: 40),
                          ),
                          Text(description)
                        ],
                      ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: SizedBox(
                width: 150,
                child: TextField(
                  controller: _cityTextController,
                  decoration: InputDecoration(labelText: 'City'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(onPressed: _search, child: Text('Search'))
          ],
        ),
      ),
    );
  }

  void _search() async {
    setState(() {
      wrong = false;
    });
    print('search started');
    setState(() => searching = true);
    final statuscode = await _dataService.statuscodes(_cityTextController.text);
    print(statuscode);

    if (statuscode == 200) {
      final response = await _dataService.getWeather(_cityTextController.text);
      setState(() {
        //_response = response;
        sityName = response.cityName!;
        temperature = response.tempInfo!.temperature!.toInt();
        description = response.weatherInfo!.description!;
      });
      setState(() {
        searching = false;
        _cityTextController.clear();
      });
    } else {
      setState(() {
        wrong = true;
      });
    }

    // print(response.cityName);
    // print(response.weatherInfo?.description);
    // print(response.weatherInfo?.description);
    // print(response.tempInfo?.temperature?.round());
  }
}
