class UserSummary {
  String userId, officialCovidTestStatus, selfCovidTestStatus, remarks;
  int creationDateTimeMillis, lastUpdateDateTimeMillis;

  UserSummary({
    this.userId,
    this.officialCovidTestStatus,
    this.selfCovidTestStatus,
    this.remarks,
    this.creationDateTimeMillis,
    this.lastUpdateDateTimeMillis,
  });

  factory UserSummary.fromJson(Map<String, dynamic> data) {
    return UserSummary(
      userId: data['userId'] ?? null,
      officialCovidTestStatus: data['officialCovidTestStatus'] ?? null,
      selfCovidTestStatus: data['selfCovidTestStatus'] ?? null,
      remarks: data['remarks'] ?? null,
      creationDateTimeMillis: data['creationDateTimeMillis'] ?? null,
      lastUpdateDateTimeMillis: data['lastUpdateDateTimeMillis'] ?? null,
    );
  }

  toJson() {
    return {
      'userId': userId ?? null,
      'officialCovidTestStatus': officialCovidTestStatus ?? null,
      'selfCovidTestStatus': selfCovidTestStatus ?? null,
      'remarks': remarks ?? null,
      'creationDateTimeMillis': creationDateTimeMillis ?? null,
      'lastUpdateDateTimeMillis': lastUpdateDateTimeMillis ?? null,
    };
  }
}
