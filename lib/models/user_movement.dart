class UserMovement {
  String userId;
  String id;
  int creationDateTimeMillis;
  double latitude;
  double longitude;

  UserMovement({
    this.userId,
    this.id,
    this.creationDateTimeMillis,
    this.latitude,
    this.longitude,
  });

  factory UserMovement.fromMap(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    return UserMovement(
      id: data['id'] ?? null,
      userId: data['userId'] ?? null,
      creationDateTimeMillis: data['creationDateTimeMillis'] ?? null,
      latitude: data['latitude'] ?? null,
      longitude: data['longitude'] ?? null,
    );
  }

  toJson() {
    return {
      'id': this.id ?? null,
      'userId': this.userId ?? null,
      'creationDateTimeMillis': this.creationDateTimeMillis ?? null,
      'latitude': this.latitude ?? null,
      'longitude': this.longitude ?? null,
    };
  }
}
