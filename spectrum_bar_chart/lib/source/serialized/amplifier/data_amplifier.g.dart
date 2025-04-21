// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_amplifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DsManualAlignmentModel _$DsManualAlignmentModelFromJson(
        Map<String, dynamic> json) =>
    DsManualAlignmentModel(
      message: json['message'],
      result: json['result'] == null
          ? null
          : DsManualAlignmentItem.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DsManualAlignmentModelToJson(
        DsManualAlignmentModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'result': instance.result,
    };

DsManualAlignmentItem _$DsManualAlignmentItemFromJson(
        Map<String, dynamic> json) =>
    DsManualAlignmentItem(
      (json['values'] as List<dynamic>)
          .map((e) => DSManualValues.fromJson(e as Map<String, dynamic>))
          .toList(),
      manual_align_ctrl_type_enum:
          (json['manual_align_ctrl_type_enum'] as num?)?.toInt(),
    )..factor = json['factor'] == null
        ? 1
        : DsManualAlignmentItem._valueFromJson(json['factor']);

Map<String, dynamic> _$DsManualAlignmentItemToJson(
        DsManualAlignmentItem instance) =>
    <String, dynamic>{
      'values': instance.dsValues,
    };

DSManualValues _$DSManualValuesFromJson(Map<String, dynamic> json) =>
    DSManualValues(
      (json['stage'] as num).toInt(),
      (json['ctrl_type'] as num).toInt(),
      (json['min_val'] as num).toDouble(),
      (json['max_val'] as num).toDouble(),
      (json['value'] as num).toDouble(),
      json['dirty'] as bool? ?? true,
    );

Map<String, dynamic> _$DSManualValuesToJson(DSManualValues instance) =>
    <String, dynamic>{
      'stage': instance.stage,
      'ctrl_type': instance.ctrlType,
      'min_val': instance.minVal,
      'max_val': instance.maxVal,
      'value': instance.value,
      'dirty': instance.dirty,
    };
