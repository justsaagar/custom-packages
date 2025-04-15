// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amplifier_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DSAutoAlignSpectrum _$DSAutoAlignSpectrumFromJson(Map<String, dynamic> json) =>
    DSAutoAlignSpectrum(
      message: json['message'],
      result: json['result'] == null
          ? null
          : DSAutoAlignSpectrumItem.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DSAutoAlignSpectrumToJson(
        DSAutoAlignSpectrum instance) =>
    <String, dynamic>{
      'message': instance.message,
      'result': instance.result,
    };

DSAutoAlignSpectrumItem _$DSAutoAlignSpectrumItemFromJson(
        Map<String, dynamic> json) =>
    DSAutoAlignSpectrumItem(
      freq: json['freq'] as List<dynamic>,
      dsSpectrumData: (json['spectrum_data'] as List<dynamic>)
          .map((e) => DSSpectrumData.fromJson(e as Map<String, dynamic>))
          .toList(),
      result: json['result'],
    );

Map<String, dynamic> _$DSAutoAlignSpectrumItemToJson(
        DSAutoAlignSpectrumItem instance) =>
    <String, dynamic>{
      'freq': instance.freq,
      'spectrum_data': instance.dsSpectrumData,
      'result': instance.result,
    };

DSSpectrumData _$DSSpectrumDataFromJson(Map<String, dynamic> json) =>
    DSSpectrumData(
      frequency: json['frequency'],
      level: json['level'],
      reference: json['reference'],
    );

Map<String, dynamic> _$DSSpectrumDataToJson(DSSpectrumData instance) =>
    <String, dynamic>{
      'frequency': instance.frequency,
      'level': instance.level,
      'reference': instance.reference,
    };
