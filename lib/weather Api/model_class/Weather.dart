class Weather {
  Location? location;
  Current? current;
  Forecast? forecast;

  Weather({this.location, this.current, this.forecast});

  Weather.fromJson(Map<String, dynamic> json)
  : location = json['location'] as String,
  current = json['current'] as String,
  forecast = json['forecast'] as String,

  Map<String, dynamic> toJson() => {'location' : location, 'current' : current, 'forecast' : forecast};
}

class Location {
  String? name;

  Location({this.name});

  Location.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }
}

class Current {
  num? tempC;
  Condition? condition;

  Current({this.tempC, this.condition});

  Current.fromJson(Map<String, dynamic> json) {
    tempC = json['temp_c'];
     Condition.fromJson(json['condition']);
  }
}

class Condition {
  String? text;
  String? icon;

  Condition({this.text, this.icon});

  Condition.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    icon = json['icon'];
  }
}

class Forecast {
  List<Forecastday>? forecastday;

  Forecast({this.forecastday});

  Forecast.fromJson(Map<String, dynamic> json) {
    if (json['forecastday'] != null) {
      forecastday =(json['forecastday'] as List).map((v) => Forecastday.fromJson(v)).toList();
    }}
}

class Forecastday {
  String? date;
  Day? day;
  List<Hour>? hour;

  Forecastday({this.date, this.day, this.hour});

  Forecastday.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'] != null ? Day.fromJson(json['day']) : null;
    if (json['hour'] != null) {
      hour = (json['hour'] as List).map((v) => Hour.fromJson(v)).toList();
    }
  }
}

class Day {
  double? maxtempC;
  double? mintempC;
  Condition? condition;

  Day({this.maxtempC, this.mintempC, this.condition});

  Day.fromJson(Map<String, dynamic> json) {
    maxtempC = (json['maxtemp_c'] as num?)?.toDouble();
    mintempC = (json['mintemp_c'] as num?)?.toDouble();
    condition =
    json['condition'] != null ? Condition.fromJson(json['condition']) : null;
  }
}

class Hour {
  String? time;
  double? tempC;
  Condition? condition;

  Hour({this.time, this.tempC, this.condition});

  Hour.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    tempC = (json['temp_c'] as num?)?.toDouble();
    condition =
    json['condition'] != null ? Condition.fromJson(json['condition']) : null;
  }
}
