import 'package:covid_app/models/corona_total_count.dart';

class CoronaCaseCountry {
  final String country;
  final int confirmed;
  final int deaths;
  final int recovered;

  CoronaCaseCountry({
    this.country,
    this.confirmed,
    this.deaths,
    this.recovered,
  });

  int get totalSick {
    return confirmed - deaths - recovered;
  }

  CoronaTotalCount get coronaTotalCount {
    return CoronaTotalCount(
      confirmed: confirmed,
      deaths: deaths,
      recovered: recovered,
    );
  }
}
