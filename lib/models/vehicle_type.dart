class VehicleType {
  final String id, label;
  final int onBoardTotalCount;

  VehicleType({
    this.id,
    this.label,
    this.onBoardTotalCount,
  });

  factory VehicleType.fromJson(Map<String, dynamic> data) {
    return VehicleType(
      id: data['id'] ?? null,
      label: data['label'] ?? null,
      onBoardTotalCount: data['onBoardTotalCount'] ?? null,
    );
  }

  toJson() {
    return {
      'id': this.id ?? null,
      'label': this.label ?? null,
      'onBoardTotalCount': this.onBoardTotalCount ?? null,
    };
  }
}
