import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String name,
      userId,
      email,
      phoneNumber,
      countryCode,
      photoUrl,
      dob,
      gender,
      loginId,
      pushToken,
      role,
      address,
      nationalIdNo,
      status;

  AppUser({
    this.name,
    this.userId,
    this.email,
    this.phoneNumber,
    this.countryCode,
    this.photoUrl,
    this.dob,
    this.gender,
    this.loginId,
    this.pushToken,
    this.role,
    this.status,
    this.address,
    this.nationalIdNo,
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data();
    return AppUser(
      name: data['name'] ?? '',
      userId: data['userId'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      countryCode: data['countryCode'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      dob: data['dob'] ?? '',
      gender: data['gender'] ?? '',
      loginId: data['loginId'] ?? '',
      pushToken: data['pushToken'] ?? null,
      role: data['role'] ?? null,
      status: data['status'] ?? null,
      nationalIdNo: data['nationalIdNo'] ?? null,
      address: data['address'] ?? null,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> data) {
    return AppUser(
      name: data['name'] ?? '',
      userId: data['userId'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      countryCode: data['countryCode'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      dob: data['dob'] ?? '',
      gender: data['gender'] ?? '',
      loginId: data['loginId'] ?? '',
      pushToken: data['pushToken'] ?? null,
      role: data['role'] ?? null,
      status: data['status'] ?? null,
      nationalIdNo: data['nationalIdNo'] ?? null,
      address: data['address'] ?? null,
    );
  }

  toJson() {
    return {
      "name": name ?? null,
      "userId": userId ?? null,
      "email": email ?? null,
      "phoneNumber": phoneNumber ?? null,
      "countryCode": countryCode ?? null,
      "photoUrl": photoUrl ?? null,
      "dob": dob ?? null,
      "gender": gender ?? null,
      "loginId": loginId ?? null,
      "pushToken": pushToken ?? null,
      "role": role ?? null,
      'status': status ?? null,
      'nationalIdNo': nationalIdNo ?? null,
      'address': address ?? null,
    };
  }

  @override
  String toString() {
    return '{name: $name, userId: $userId, email: $email, phoneNumber: $phoneNumber, countryCode: $countryCode, photoUrl: $photoUrl, dob: $dob, gender: $gender, loginId: $loginId, pushToken: $pushToken, role: $role, status: $status}';
  }
}
