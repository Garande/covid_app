// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'corona_count_features.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoronaCountFeatures _$CoronaCountFeaturesFromJson(Map<String, dynamic> json) {
  return CoronaCountFeatures(
    attributes: json['attributes'] == null
        ? null
        : CoronaCountAttributes.fromJson(
            json['attributes'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CoronaCountFeaturesToJson(
        CoronaCountFeatures instance) =>
    <String, dynamic>{
      'attributes': instance.attributes,
    };
