// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'corona_count_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoronaCountResponse _$CoronaCountResponseFromJson(Map<String, dynamic> json) {
  return CoronaCountResponse(
    features: (json['features'] as List)
        ?.map((e) => e == null
            ? null
            : CoronaCountFeatures.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CoronaCountResponseToJson(
        CoronaCountResponse instance) =>
    <String, dynamic>{
      'features': instance.features,
    };
