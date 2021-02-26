import 'package:covid_app/models/corona_count_features.dart';
import 'package:json_annotation/json_annotation.dart';
part 'corona_count_response.g.dart';

@JsonSerializable()
class CoronaCountResponse {
  final List<CoronaCountFeatures> features;

  CoronaCountResponse({this.features});

  factory CoronaCountResponse.fromJson(Map<String, dynamic> json) =>
      _$CoronaCountResponseFromJson(json);
  Map<String, dynamic> toJSON() => _$CoronaCountResponseToJson(this);
}
