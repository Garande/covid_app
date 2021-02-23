import 'package:covid_app/models/country.dart';
import 'package:covid_app/providers/countriesProvider.dart';

class CountriesRepository {
  final countriesProvider = CountriesProvider();
  Future<List<Country>> loadCountriesJson() =>
      countriesProvider.loadCountriesJson();

  Future<List<Country>> searchCountry(String query, var countries) =>
      countriesProvider.searchCountry(query, countries);

  Future<Country> getCountryByDialCode(String dialCode) =>
      countriesProvider.getCountryByDialCode(dialCode);
}
