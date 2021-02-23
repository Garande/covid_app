class Country {
  String name, code, dialCode, flag, currency;

  Country({this.name, this.code, this.dialCode, this.flag, this.currency});

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        name: json["name"],
        code: json["code"],
        dialCode: json["dial_code"],
        flag: json["flag"],
        currency: json["currency_code"],
      );

  @override
  String toString() {
    return 'Country{name: $name, code: $code, dialCode: $dialCode, currency: $currency}';
  }
}
