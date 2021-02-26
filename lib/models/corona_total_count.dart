import 'package:covid_app/utils/helper.dart';

class CoronaTotalCount {
  final int confirmed;
  final int deaths;
  final int recovered;

  CoronaTotalCount({
    this.confirmed,
    this.deaths,
    this.recovered,
  });

  String get confirmedString {
    return Helper.formatNumber(confirmed);
  }

  String get deathsString {
    return Helper.formatNumber(deaths);
  }

  String get recoveredString {
    return Helper.formatNumber(recovered);
  }

  int get sick {
    return confirmed - deaths - recovered;
  }

  double get recoveryRate {
    return (recovered.toDouble() / confirmed.toDouble()) * 100;
  }

  double get fatalityRate {
    return (deaths.toDouble() / confirmed.toDouble()) * 100;
  }

  String get sickString {
    return Helper.formatNumber(sick);
  }

  double get sickRate {
    return (sick.toDouble() / confirmed.toDouble()) * 100;
  }

  String get recoveryRateString {
    return "${recoveryRate.toStringAsFixed(2)}%";
  }

  String get fatalityRateString {
    return "${fatalityRate.toStringAsFixed(2)}%";
  }
}
