import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:covid_app/blocs/authentication/authentication_bloc.dart';
import 'package:covid_app/models/corona_case.dart';
import 'package:covid_app/models/corona_case_country.dart';
import 'package:covid_app/models/corona_case_response.dart';
import 'package:covid_app/models/corona_count_response.dart';
import 'package:covid_app/models/corona_total_count.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'corona_event.dart';
part 'corona_state.dart';

class CoronaBloc extends Bloc<CoronaEvent, CoronaState> {
  CoronaBloc() : super(null);

  @override
  CoronaState get initialState => Uninitialized();

  var timeoutDuration = Duration(
    seconds: 25,
  );

  @override
  Stream<CoronaState> mapEventToState(event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

  static var baseURL =
      'https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query';

  static String get caseURL {
    return '$baseURL?f=json&where=(Confirmed%3E%200)%20OR%20(Deaths%3E0)%20OR%20(Recovered%3E0)&returnGeometry=false&spatialRef=esriSpatialRelIntersects&outFields=*&orderByFields=Country_Region%20asc,Province_State%20asc&resultOffset=0&resultRecordCount=250&cacheHint=false';
  }

  static String get totalConfirmedCaseURL {
    return '$baseURL?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22,%22onStatisticField%22%3A%22Confirmed%22,%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=false';
  }

  static String get totalRecoveredCaseURL {
    return '$baseURL?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22%3A%22sum%22,%22onStatisticField%22%3A%22Recovered%22,%22outStatisticFieldName%22%3A%22value%22%7D%5D&cacheHint=false';
  }

  static String get totalDeathsCaseURL {
    return '$baseURL?f=json&where=Confirmed%20%3E%200&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=%5B%7B%22statisticType%22:%22sum%22,%22onStatisticField%22:%22Deaths%22,%22outStatisticFieldName%22:%22value%22%7D%5D&cacheHint=false';
  }

  Future<CoronaTotalCount> fetchAllTotalCount() async {
    try {
      final confirmedJson = await _fetchJSON(totalConfirmedCaseURL);
      final deathsJson = await _fetchJSON(totalDeathsCaseURL);
      final recoveredJson = await _fetchJSON(totalRecoveredCaseURL);

      final confirmed = CoronaCountResponse.fromJson(confirmedJson)
          .features
          .first
          .attributes
          .value;
      final deaths = CoronaCountResponse.fromJson(deathsJson)
          .features
          .first
          .attributes
          .value;
      final recovered = CoronaCountResponse.fromJson(recoveredJson)
          .features
          .first
          .attributes
          .value;

      if (confirmed == null || deaths == null || recovered == null) {
        throw ServerException();
      }

      return CoronaTotalCount(
          confirmed: confirmed, deaths: deaths, recovered: recovered);
    } on PlatformException catch (_) {
      throw ServerException();
    } on Exception catch (e) {
      throw e;
    } catch (e) {
      // throw e;
    }
  }

  Future<List<CoronaCaseCountry>> fetchCases() async {
    try {
      final url = caseURL;
      final json = await _fetchJSON(url);
      final response = CoronaCaseResponse.fromJson(json);
      final coronaCases = response.features.map((e) => e.attributes).toList();

      Map<String, List<CoronaCase>> dict = Map();
      coronaCases.forEach((element) {
        if (dict[element.country] != null) {
          var countryCases = dict[element.country];
          countryCases.add(element);
          dict[element.country] = countryCases;
        } else {
          var countryCases = List<CoronaCase>();
          countryCases.add(element);
          dict[element.country] = countryCases;
        }
      });

      var coronaCountryCases = List<CoronaCaseCountry>();
      dict.forEach((key, value) {
        final confirmed = value.fold(
            0, (previousValue, element) => previousValue + element.confirmed);
        final deaths = value.fold(
            0, (previousValue, element) => previousValue + element.deaths);
        final recovered = value.fold(
            0, (previousValue, element) => previousValue + element.recovered);
        coronaCountryCases.add(CoronaCaseCountry(
          country: key,
          confirmed: confirmed,
          deaths: deaths,
          recovered: recovered,
          // cases: value,
        ));
      });

      coronaCountryCases.sort((a, b) => b.recovered - a.recovered);
      coronaCountryCases.sort((a, b) => b.deaths - a.deaths);
      coronaCountryCases.sort((a, b) => b.confirmed - a.confirmed);

      return coronaCountryCases;
    } on PlatformException catch (_) {
      throw ServerException();
    } on Exception catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> _fetchJSON(String url) async {
    final response =
        await http.get(url).timeout(Duration(seconds: 25), onTimeout: () {
      throw Error();
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerErrorException("Error retrieving data");
    }
  }
}
