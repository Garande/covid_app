class Address {
  final String name;
  final double latitude;
  final double longitude;
  final double accuracy;
  final int creationDateTimeMillis;

  Address({
    this.name,
    this.latitude,
    this.longitude,
    this.accuracy,
    this.creationDateTimeMillis,
  });

  factory Address.fromJson(Map<String, dynamic> data) {
    if (data == null) return null;

    return Address(
      name: data['name'] ?? null,
      latitude: data['latitude'] ?? null,
      longitude: data['longitude'] ?? null,
      accuracy: data['accuracy'] ?? null,
      creationDateTimeMillis: data['creationDateTimeMillis'] ?? null,
    );
  }

  toJson() {
    return {
      'name': this.name ?? null,
      'latitude': this.latitude ?? null,
      'longitude': this.longitude ?? null,
      'accuracy': this.accuracy ?? null,
      'creationDateTimeMillis': this.creationDateTimeMillis ?? null,
    };
  }
}
