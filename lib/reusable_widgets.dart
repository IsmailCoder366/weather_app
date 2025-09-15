import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class AnimatedBackground extends StatelessWidget {
  final String condition;

  const AnimatedBackground({super.key, required this.condition});

  @override
  Widget build(BuildContext context) {
    // Pick gradient based on condition
    final gradient = _getGradient(condition); // Use the condition to get the appropriate gradient

    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      decoration: BoxDecoration(
        gradient: gradient
      ),
    );
  }

  LinearGradient _getGradient(condition) {
    switch (condition.toLowerCase()) { // Convert to lowercase for case-insensitive comparison
      case "sunny":
        return const LinearGradient(
          colors: [Color(0xfff6d365), Color(0xfffda085)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case "cloudy":
        return const LinearGradient(
          colors: [Color(0xffbdc3c7), Color(0xff2c3e50)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case "rain":
        return const LinearGradient(
          colors: [Color(0xff00c6fb), Color(0xff005bea)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case "mist":
        return const LinearGradient(
          colors: [Color(0xffd7d2cc), Color(0xff304352)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      case "snow":
        return const LinearGradient(
          colors: [Color(0xffe0eafc), Color(0xffcfdef3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case "thunderstorm":
        return const LinearGradient(
          colors: [Color(0xff141e30), Color(0xff243b55)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case "partly cloudy":
        return const LinearGradient(
          begin: Alignment.topCenter,
          colors: [Color(0xff667db6), Color(0xff0082c8), Color(0xff0082c8), Color(0xff667db6)],
          end: Alignment.bottomCenter,
        );
      case "overcast":
        return const LinearGradient(
          colors: [Color(0xff757f9a), Color(0xffd7dde8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case "fog":
        return const LinearGradient(
          colors: [Color(0xff3e5151), Color(0xffdecba9)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case "haze":
        return const LinearGradient(
          colors: [Color(0xfff3904f), Color(0xff3b4371)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case "drizzle":
        return const LinearGradient(
          colors: [Color(0xff89f7fe), Color(0xff66a6ff)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );

      default:
        return const LinearGradient(
          colors: [Color(0xff6cabf8), Color(0xff428de8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}

class CurrentWeatherCard extends StatelessWidget {
  final String city;
  final int temp;
  final String condition;
  final int maxTemp;
  final int minTemp;

  const CurrentWeatherCard({
    super.key,
    required this.city,
    required this.temp,
    required this.condition,
    required this.maxTemp,
    required this.minTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                city,
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.location_on_outlined,
                  color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            "$temp°",
            style: const TextStyle(
              fontSize: 60,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            condition,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(
            "$maxTemp° / $minTemp°",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class HourlyForecastTile extends StatelessWidget {
  final String hour;
  final String iconUrl;
  final int temp;

  const HourlyForecastTile({
    super.key,
    required this.hour,
    required this.iconUrl,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hour,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Image.network(iconUrl, width: 40, height: 40),
          const SizedBox(height: 6),
          Text(
            "$temp°",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class ForecastDayTile extends StatelessWidget {
  final String formattedDate;
  final String dayName;
  final String iconUrl;
  final int minTemp;
  final int maxTemp;

  const ForecastDayTile({
    super.key,
    required this.formattedDate,
    required this.dayName,
    required this.iconUrl,
    required this.minTemp,
    required this.maxTemp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(formattedDate,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Text(dayName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const Spacer(),
          Image.network(iconUrl, width: 40, height: 40),
          const Spacer(),
          Text(
            "$minTemp° / $maxTemp°",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


