import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model_class/getWeather.dart';

class WeatherApi extends StatefulWidget {
  const WeatherApi({super.key});

  @override
  State<WeatherApi> createState() => _WeatherApiState();
}

class _WeatherApiState extends State<WeatherApi> {
  String url = "https://api.weatherapi.com/v1/forecast.json?key=b028abc92fe2455dac3113350251405&q=Kohat&days=3&aqi=yes&alerts=yes";




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(

        future: http.get(Uri.parse(url)),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

              final data = jsonDecode(snapshot.data!.body);
             Weather weather = Weather.fromJson(data);


            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5YQdJx0hSYqDMG90yi9XRSo3Y8yS5MWTsFw&s",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 50),

                    // Current weather card
                    Column(
                      children: [
                        Text(
                          weather.location!.name!,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "${weather.current!.tempC.toString()}\u00B0C",
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          weather.current!.condition!.text!,
                          style: TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                        SizedBox(height: 8),

                        Text(
                          "H: ${weather.forecast!.forecastday![0].day!.maxtempC}°  L: ${weather.forecast!.forecastday![0].day!.mintempC}°",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 30),

                    // Hourly forecast
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                             weather.forecast!.forecastday![0].hour!.length,
                          itemBuilder: (context, index) {

                                weather.forecast!.forecastday![0].hour![index];
                            return Container(
                              width: 90,
                              margin: EdgeInsets.symmetric(horizontal: 8),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                height: 150,
                                width: 120,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.indigo.withOpacity(0.6),
                                      Colors.blue.withOpacity(0.4),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                              )
                                  ]
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weather.forecast!.forecastday![0].hour![index].time.toString().split(" ")[1],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Image.network(
                                  "https:${weather.forecast!.forecastday![0].hour![index].condition!.icon!}",
                                  width: 40,
                                  height: 40,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "${weather.forecast!.forecastday![0].hour![index].tempC}°C",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                            )));
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Next 7 days forecast (vertical)
                    ListView.builder(

                      shrinkWrap: true,
                      itemCount: data['forecast']['forecastday'].length,
                      itemBuilder: (context, index) {
                        data['forecast']['forecastday'][index];
                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.indigo.withOpacity(0.6),
                                Colors.blue.withOpacity(0.4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 5,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['forecast']['forecastday'][index]['date'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Image.network(
                                    "https:${data['forecast']['forecastday'][index]['day']['condition']['icon']}",
                                    width: 40,
                                    height: 40,
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "H: ${data['forecast']['forecastday'][index]['day']['maxtemp_c']}°  L: ${data['forecast']['forecastday'][index]['day']['mintemp_c']}°",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
