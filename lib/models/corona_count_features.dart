import 'package:covid_app/models/corona_count_attributes.dart';
import 'package:json_annotation/json_annotation.dart';

part 'corona_count_features.g.dart';

@JsonSerializable()
class CoronaCountFeatures {
  final CoronaCountAttributes attributes;

  CoronaCountFeatures({this.attributes});

  factory CoronaCountFeatures.fromJson(Map<String, dynamic> json) =>
      _$CoronaCountFeaturesFromJson(json);
  Map<String, dynamic> toJSON() => _$CoronaCountFeaturesToJson(this);
}
