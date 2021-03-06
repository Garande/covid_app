import 'package:covid_app/models/address.dart';

class Trip {
  String id;
  String userId;
  String peerId;
  int creationDateTimeMillis;
  int lastUpdateDateTimeMillis;
  String status;
  String passengerNationalIdNo;
  String passengerName;
  String passengerPhoneNumber;
  Address addressFrom;
  Address addressTo;

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
    this.peerId,
  });

  factory Trip.fromJson(var data) {
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
      peerId: data['peerId'] ?? null,
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
      'addressFrom':
          this.addressFrom != null ? this.addressFrom.toJson() ?? null : null,
      'addressTo':
          this.addressTo != null ? this.addressTo.toJson() ?? null : null,
      'peerId': this.peerId ?? null,
    };
  }
}
