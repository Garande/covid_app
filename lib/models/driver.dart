class Driver {
  final String userId;
  final String vehicleType;
  final String permitNo;
  final String permitUrl;
  final String plateNumber;
  final String status;
  final String vehicleStatus;
  final String vehicleOnBoardCount;

  Driver({
    this.userId,
    this.vehicleType,
    this.permitNo,
    this.permitUrl,
    this.plateNumber,
    this.status,
    this.vehicleStatus,
    this.vehicleOnBoardCount,
  });

  factory Driver.fromJson(Map<String, dynamic> data) {
    if (data == null) {
      return null;
    }

    return Driver(
      userId: data['userId'] ?? null,
      vehicleType: data['vehicleType'] ?? null,
      permitNo: data['permitNo'] ?? null,
      permitUrl: data['permitUrl'] ?? null,
      plateNumber: data['plateNumber'] ?? null,
      status: data['status'] ?? null,
      vehicleStatus: data['vehicleStatus'] ?? null,
      vehicleOnBoardCount: data['vehicleOnBoardCount'] ?? null,
    );
  }

  toJson() {
    return {
      'userId': this.userId ?? null,
      'vehicleType': this.vehicleType ?? null,
      'permitNo': this.permitNo ?? null,
      'permitUrl': this.permitUrl ?? null,
      'plateNumber': this.plateNumber ?? null,
      'status': this.status ?? null,
      'vehicleStatus': this.vehicleStatus ?? null,
      'vehicleOnBoardCount': this.vehicleOnBoardCount ?? null,
    };
  }
}
