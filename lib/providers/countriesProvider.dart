import 'dart:convert';

import 'package:covid_app/models/country.dart';
import 'package:flutter/services.dart';

class CountriesProvider {
  Future<List<Country>> loadCountriesJson() async {
    List<Country> countries = [];
    var value = await rootBundle.loadString("data/country_phone_codes.json");
    var countriesJson = json.decode(value);
    for (var country in countriesJson) {
      countries.add(Country.fromJson(country));
    }
    return countries;
  }

  Future<List<Country>> searchCountry(String query, var countries) async {
    List<Country> searchResults = [];
    if (query.length == 0) {
      searchResults.clear();
      searchResults = countries;
    } else {
      countries.forEach((Country c) {
        if (c.toString().toLowerCase().contains(query.toLowerCase()))
          searchResults.add(c);
      });
    }

    return searchResults;
  }

  Future<Country> getCountryByDialCode(String dialCode) async {
    List<Country> countries = await loadCountriesJson();
    return countries.singleWhere((country) => country.dialCode == dialCode);
  }
}
