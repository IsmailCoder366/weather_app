import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../reusable_widgets.dart';
import 'model_class/Weather.dart';

class WeatherApi extends StatefulWidget {
  const WeatherApi({super.key});

  @override
  State<WeatherApi> createState() => _WeatherApiState();
}

class _WeatherApiState extends State<WeatherApi> {
  final getWeather = http.get(Uri.parse(
      "https://api.weatherapi.com/v1/forecast.json?key=b028abc92fe2455dac3113350251405&q=Kohat&days=3&aqi=yes&alerts=yes"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff6cabf8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: getWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          final data = jsonDecode(snapshot.data!.body);
          Weather weather = Weather.fromJson(data);

          // Today + Tomorrow’s hours for 24h scroll
          final todayHours = weather.forecast!.forecastday![0].hour!;
          final tomorrowHours =
          weather.forecast!.forecastday!.length > 1 ? weather.forecast!.forecastday![1].hour! : [];
          final allHours = [...todayHours, ...tomorrowHours];

          int currentHour = DateTime.now().hour;
          int startIndex = allHours.indexWhere(
                  (h) => DateTime.parse(h.time!).hour >= currentHour);
          if (startIndex == -1) startIndex = 0;

          final next24 = allHours.skip(startIndex).take(24).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Current Weather Card
                CurrentWeatherCard(
                  city: weather.location!.name!,
                  temp: weather.current!.tempC!.round(),
                  condition: weather.current!.condition!.text!,
                  maxTemp: weather.forecast!.forecastday![0].day!.maxtempC!.round(),
                  minTemp: weather.forecast!.forecastday![0].day!.mintempC!.round(),
                ),

                const SizedBox(height: 20),

                // Hourly Forecast
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: next24.length,
                    itemBuilder: (context, index) {
                      final hour = next24[index];
                      String formattedHour =
                      DateFormat.Hm().format(DateTime.parse(hour.time!));
                      return HourlyForecastTile(
                        hour: formattedHour,
                        iconUrl: "https:${hour.condition!.icon!}",
                        temp: hour.tempC!.round(),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Daily Forecast
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xff66a2ed),
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
                        iconUrl: "https:${day.day!.condition!.icon!}",
                        minTemp: day.day!.mintempC!.round(),
                        maxTemp: day.day!.maxtempC!.round(),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
