import 'package:json_annotation/json_annotation.dart';

part 'corona_count_attributes.g.dart';

@JsonSerializable()
class CoronaCountAttributes {
  final int value;

  CoronaCountAttributes({this.value});

  factory CoronaCountAttributes.fromJson(Map<String, dynamic> json) =>
      _$CoronaCountAttributesFromJson(json);
  Map<String, dynamic> toJSON() => _$CoronaCountAttributesToJson(this);
}
