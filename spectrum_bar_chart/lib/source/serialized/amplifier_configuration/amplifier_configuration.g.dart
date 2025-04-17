// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amplifier_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DsAutoAlignmentModel _$DsAutoAlignmentModelFromJson(
        Map<String, dynamic> json) =>
    DsAutoAlignmentModel(
      message: json['message'],
      result: json['result'] == null
          ? null
          : DsAutoAlignmentItem.fromJson(
              json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DsAutoAlignmentModelToJson(
        DsAutoAlignmentModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'result': instance.result,
    };

DsAutoAlignmentItem _$DsAutoAlignmentItemFromJson(Map<String, dynamic> json) =>
    DsAutoAlignmentItem(
      sampDownstreamAutoAlignStatus:
          json['samp_downstream_auto_align_status'] == null
              ? null
              : SampDownstreamAutoAlignStatus.fromJson(
                  json['samp_downstream_auto_align_status']
                      as Map<String, dynamic>),
      dsValues: (json['spectrum_values'] as List<dynamic>?)
          ?.map((e) => DSValue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DsAutoAlignmentItemToJson(
        DsAutoAlignmentItem instance) =>
    <String, dynamic>{
      'samp_downstream_auto_align_status':
          instance.sampDownstreamAutoAlignStatus,
      'spectrum_values': instance.dsValues,
    };

SampDownstreamAutoAlignStatus _$SampDownstreamAutoAlignStatusFromJson(
        Map<String, dynamic> json) =>
    SampDownstreamAutoAlignStatus(
      autoAlignStatus: json['auto_align_status'],
      rfDetMode: json['rf_det_mode'],
      errorCode: json['error_code'],
      errorDesc: json['error_desc'],
      result: json['result'],
      csmCableLength: json['csm_cable_length'],
      csmGamma: json['csm_gamma'],
      csmPhi: json['csm_phi'],
    );

Map<String, dynamic> _$SampDownstreamAutoAlignStatusToJson(
        SampDownstreamAutoAlignStatus instance) =>
    <String, dynamic>{
      'auto_align_status': instance.autoAlignStatus,
      'rf_det_mode': instance.rfDetMode,
      'error_code': instance.errorCode,
      'error_desc': instance.errorDesc,
      'result': instance.result,
      'csm_cable_length': instance.csmCableLength,
      'csm_gamma': instance.csmGamma,
      'csm_phi': instance.csmPhi,
    };

DSValue _$DSValueFromJson(Map<String, dynamic> json) => DSValue(
      startFreq: json['start_freq'],
      stepSize: json['step_size'],
      endFreq: json['end_freq'],
      dsSpectrumValues: json['values'] as List<dynamic>?,
    );

Map<String, dynamic> _$DSValueToJson(DSValue instance) => <String, dynamic>{
      'start_freq': instance.startFreq,
      'step_size': instance.stepSize,
      'end_freq': instance.endFreq,
      'values': instance.dsSpectrumValues,
    };

AmpDownStreamModel _$AmpDownStreamModelFromJson(Map<String, dynamic> json) =>
    AmpDownStreamModel(
      message: json['message'] as String,
      result:
          AmpDownStreamItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AmpDownStreamModelToJson(AmpDownStreamModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'result': instance.result,
    };

AmpDownStreamItem _$AmpDownStreamItemFromJson(Map<String, dynamic> json) =>
    AmpDownStreamItem(
      downGain: json['gain'],
      downSlope: json['slope'],
      agcConfig: json['agc_config'],
      universalPlugin: json['univ_plugin_present'],
      downResult: json['result'],
    );

Map<String, dynamic> _$AmpDownStreamItemToJson(AmpDownStreamItem instance) =>
    <String, dynamic>{
      'gain': instance.downGain,
      'slope': instance.downSlope,
      'agc_config': instance.agcConfig,
      'univ_plugin_present': instance.universalPlugin,
      'result': instance.downResult,
    };

AmpUpStreamModel _$AmpUpStreamModelFromJson(Map<String, dynamic> json) =>
    AmpUpStreamModel(
      message: json['message'] as String,
      result: AmpUpStreamItem.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AmpUpStreamModelToJson(AmpUpStreamModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'result': instance.result,
    };

AmpUpStreamItem _$AmpUpStreamItemFromJson(Map<String, dynamic> json) =>
    AmpUpStreamItem(
      upGain: json['gain'],
      upSlope: json['slope'],
      ingressSwitch: json['ingress_switch'],
      upResult: json['result'],
    );

Map<String, dynamic> _$AmpUpStreamItemToJson(AmpUpStreamItem instance) =>
    <String, dynamic>{
      'gain': instance.upGain,
      'slope': instance.upSlope,
      'ingress_switch': instance.ingressSwitch,
      'result': instance.upResult,
    };

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
