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
  });

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data;
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
    );
  }

  toJson() {
    return {
      "name": name,
      "userId": userId,
      "email": email,
      "phoneNumber": phoneNumber,
      "countryCode": countryCode,
      "photoUrl": photoUrl,
      "dob": dob,
      "gender": gender,
      "loginId": loginId,
      "pushToken": pushToken,
      "role": role,
      'status': status,
    };
  }

  @override
  String toString() {
    return '{name: $name, userId: $userId, email: $email, phoneNumber: $phoneNumber, countryCode: $countryCode, photoUrl: $photoUrl, dob: $dob, gender: $gender, loginId: $loginId, pushToken: $pushToken, role: $role, status: $status}';
  }
}
