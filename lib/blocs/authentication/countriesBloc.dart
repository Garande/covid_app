import 'dart:async';

import 'package:covid_app/models/country.dart';
import 'package:covid_app/repositories/countriesRepository.dart';
import 'package:equatable/equatable.dart';

enum CountriesDataState { Ready, Searching }

class CountriesBloc {
  final _countriesRepository = CountriesRepository();

  final _contriesController = StreamController<List<Country>>.broadcast();
  final _searchController = StreamController<List<Country>>.broadcast();

  get countries => _contriesController.stream;
  get searchResults => _searchController.stream;

  List<Country> myCountries = [];

  CountriesBloc() {
    fetchCountries();
  }

  Future<Stream<CountriesState>> fetchCountries() async {
    _contriesController.sink
        .add(await _countriesRepository.loadCountriesJson());
    myCountries = await _countriesRepository.loadCountriesJson();

    return null;
  }

  Future<List<Country>> searchCountry(String query) async {
    var results = await _countriesRepository.searchCountry(query, myCountries);
    _searchController.sink.add(results);

    return results;
    // return results;
  }

  int getCountryIndexByCode(String countryCode) {
    int x;
    for (int i = 0; i < myCountries.length; i++) {
      if (myCountries[i].dialCode == countryCode) {
        x = i;
        break;
      }
    }

    return x;
  }

  String getCountryCodeFromIndex(int index) {
    return myCountries[index].dialCode;
  }

  dispose() {
    _searchController.close();
    _contriesController.close();
  }

  Future<Country> getCountryByDialCode(String countryCode) =>
      _countriesRepository.getCountryByDialCode(countryCode);
}

abstract class CountriesState extends Equatable {
  const CountriesState();
}

class IsDataFormed extends CountriesState {
  @override
  String toString() => 'IsDataFormed';

  @override
  List<Object> get props => [];
}
