import 'package:covid_app/models/address.dart';

class Trip {
  final String id;
  final String userId;
  final String driverId;
  final int creationDateTimeMillis;
  final int lastUpdateDateTimeMillis;
  final String status;
  final String passengerNationalIdNo;
  final String passengerName;
  final String passengerPhoneNumber;
  final Address addressFrom;
  final Address addressTo;

  Trip({
    this.id,
    this.userId,
    this.creationDateTimeMillis,
    this.lastUpdateDateTimeMillis,
    this.status,
    this.passengerNationalIdNo,
    this.passengerName,
    this.passengerPhoneNumber,
    this.addressFrom,
    this.addressTo,
    this.driverId,
  });

  factory Trip.fromJson(Map<String, dynamic> data) {
    if (data == null) return null;

    return Trip(
      id: data['id'] ?? null,
      userId: data['userId'] ?? null,
      creationDateTimeMillis: data['creationDateTimeMillis'] ?? null,
      lastUpdateDateTimeMillis: data['lastUpdateDateTimeMillis'] ?? null,
      status: data['status'] ?? null,
      passengerNationalIdNo: data['passengerNationalIdNo'] ?? null,
      passengerName: data['passengerName'] ?? null,
      passengerPhoneNumber: data['passengerPhoneNumber'] ?? null,
      addressFrom: Address.fromJson(data['addressFrom']) ?? null,
      addressTo: Address.fromJson(data['addressTo']) ?? null,
      driverId: data['driverId'] ?? null,
    );
  }

  toJson() {
    return {
      'id': this.id ?? null,
      'userId': this.userId ?? null,
      'creationDateTimeMillis': this.creationDateTimeMillis ?? null,
      'lastUpdateDateTimeMillis': this.lastUpdateDateTimeMillis ?? null,
      'status': this.status ?? null,
      'passengerNationalIdNo': this.passengerNationalIdNo ?? null,
      'passengerName': this.passengerName ?? null,
      'passengerPhoneNumber': this.passengerPhoneNumber ?? null,
      'addressFrom': this.addressFrom.toJson() ?? null,
      'addressTo': this.addressTo.toJson() ?? null,
      'driverId': this.driverId ?? null,
    };
  }
}
