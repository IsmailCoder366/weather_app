import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import '../reusable_widgets.dart';
import 'model_class/Weather.dart';




class WeatherApi extends StatefulWidget {
  const WeatherApi({super.key});

  @override
  State<WeatherApi> createState() => _WeatherApiState();
}

class _WeatherApiState extends State<WeatherApi> {
  var searchCity = TextEditingController();
  String _city = "Kohat";
  late Future<http.Response> _futureWeather;

  @override
  void initState() {
    super.initState();
    _futureWeather = fetchWeather(_city);
  }

  Future<http.Response> fetchWeather(String city) {
    return http.get(
      Uri.parse(
        "https://api.weatherapi.com/v1/forecast.json?key=b028abc92fe2455dac3113350251405&q=$city&days=3&aqi=yes&alerts=yes",
      ),
    );
  }

  void _search() {
    if (searchCity.text.isNotEmpty) {
      setState(() {
        _city = searchCity.text.trim();
        _futureWeather = fetchWeather(_city); // refresh
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureWeather,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        final data = jsonDecode(snapshot.data!.body);

        if (data["error"] != null) {
          return Scaffold(

            backgroundColor: Colors.black,
            body: Center(
              child: Text(
                " City not found",
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          );
        }

        Weather weather = Weather.fromJson(data);

        final todayHours = weather.forecast!.forecastday![0].hour!;
        final tomorrowHours = weather.forecast!.forecastday![1].hour!;
        final allHours = todayHours + tomorrowHours;
        final currentCondition = weather.current!.condition!.text!;

        int currentHour = DateTime.now().hour;
        int startIndex = allHours.indexWhere(
              (h) => DateTime.parse(h.time!).hour >= currentHour,
        );
        if (startIndex == -1) startIndex = 0;

        final next24 = allHours.skip(startIndex).take(24).toList();

        return Stack(
          children: [
            AnimatedBackground(condition: currentCondition),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    _futureWeather = fetchWeather(_city);
                  });
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(), // ✅ needed
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: searchCity,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search city name',
                                  hintStyle:
                                  const TextStyle(color: Colors.white70),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                    const BorderSide(color: Colors.white),
                                  ),
                                ),
                                onFieldSubmitted: (_) => _search(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: _search,
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),


                      CurrentWeatherCard(
                        city: weather.location!.name!,
                        temp: weather.current!.tempC!.round(),
                        condition: weather.current!.condition!.text!,
                        maxTemp: weather
                            .forecast!.forecastday![0].day!.maxtempC!
                            .round(),
                        minTemp: weather
                            .forecast!.forecastday![0].day!.mintempC!
                            .round(),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Hourly Forecast
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: next24.length,
                          itemBuilder: (context, index) {
                            final hour = next24[index];
                            String formattedHour = DateFormat.Hm().format(
                              DateTime.parse(hour.time!),
                            );
                            return HourlyForecastTile(
                              hour: formattedHour,
                              iconUrl: "https:${hour.condition!.icon!}",
                              temp: hour.tempC!.round(),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Daily Forecast
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: weather.forecast!.forecastday!.length,
                          itemBuilder: (context, index) {
                            final day = weather.forecast!.forecastday![index];
                            DateTime date = DateTime.parse(day.date!);
                            String formattedDate =
                            DateFormat("M/d").format(date);
                            String dayName = DateFormat("E").format(date);

                            return ForecastDayTile(
                              formattedDate: formattedDate,
                              dayName: dayName,
                              iconUrl:
                              "https:${day.day!.condition!.icon!}",
                              minTemp: day.day!.mintempC!.round(),
                              maxTemp: day.day!.maxtempC!.round(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
