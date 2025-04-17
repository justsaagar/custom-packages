import 'package:json_annotation/json_annotation.dart';

part 'amplifier_configuration.g.dart';


@JsonSerializable()
class DsAutoAlignmentModel {

  dynamic message;
  @JsonKey(name: 'result')
  DsAutoAlignmentItem? result;

  DsAutoAlignmentModel({this.message, this.result});

  factory DsAutoAlignmentModel.fromJson(Map<String, dynamic> json) =>
      _$DsAutoAlignmentModelFromJson(json);

  DsAutoAlignmentModel.empty();

  Map<String, dynamic> toJson() => _$DsAutoAlignmentModelToJson(this);
}

@JsonSerializable()
class DsAutoAlignmentItem {
  @JsonKey(name: "samp_downstream_auto_align_status")
  SampDownstreamAutoAlignStatus ?sampDownstreamAutoAlignStatus;
  @JsonKey(name: "spectrum_values")
  List<DSValue> ?dsValues;

  DsAutoAlignmentItem({
    this.sampDownstreamAutoAlignStatus,
    this.dsValues,
  });

  factory DsAutoAlignmentItem.fromJson(Map<String, dynamic> json) => _$DsAutoAlignmentItemFromJson(json);

  Map<String, dynamic> toJson() => _$DsAutoAlignmentItemToJson(this);
}

@JsonSerializable()
class SampDownstreamAutoAlignStatus {
  @JsonKey(name: "auto_align_status")
  dynamic autoAlignStatus;
  @JsonKey(name: "rf_det_mode")
  dynamic rfDetMode;
  @JsonKey(name: "error_code")
  dynamic errorCode;
  @JsonKey(name: "error_desc")
  dynamic errorDesc;
  @JsonKey(name: "result")
  dynamic result;
  @JsonKey(name: "csm_cable_length")
  dynamic csmCableLength;
  @JsonKey(name: "csm_gamma")
  dynamic csmGamma;
  @JsonKey(name: "csm_phi")
  dynamic csmPhi;

  SampDownstreamAutoAlignStatus({
    this.autoAlignStatus,
    this.rfDetMode,
    this.errorCode,
    this.errorDesc,
    this.result,
    this.csmCableLength,
    this.csmGamma,
    this.csmPhi,
  });

  factory SampDownstreamAutoAlignStatus.fromJson(Map<String, dynamic> json) => _$SampDownstreamAutoAlignStatusFromJson(json);

  Map<String, dynamic> toJson() => _$SampDownstreamAutoAlignStatusToJson(this);
}

@JsonSerializable()
class DSValue {
  @JsonKey(name: "start_freq")
  dynamic startFreq;
  @JsonKey(name: "step_size")
  dynamic stepSize;
  @JsonKey(name: "end_freq")
  dynamic endFreq;
  @JsonKey(name: "values")
  List<dynamic>? dsSpectrumValues;

  DSValue({
    this.startFreq,
    this.stepSize,
    this.endFreq,
    this.dsSpectrumValues,
  });

  factory DSValue.fromJson(Map<String, dynamic> json) => _$DSValueFromJson(json);

  Map<String, dynamic> toJson() => _$DSValueToJson(this);
}

@JsonSerializable()
class AmpDownStreamModel {
  String message;
  AmpDownStreamItem result;

  AmpDownStreamModel({
    required this.message,
    required this.result,
  });

  factory AmpDownStreamModel.fromJson(Map<String, dynamic> json) =>
      _$AmpDownStreamModelFromJson(json);

  Map<String, dynamic> toJson() => _$AmpDownStreamModelToJson(this);
}

@JsonSerializable()
class AmpDownStreamItem {
  @JsonKey(name: 'gain')
  dynamic downGain;
  @JsonKey(name: 'slope')
  dynamic downSlope;
  @JsonKey(name: 'agc_config')
  dynamic agcConfig;
  @JsonKey(name: 'univ_plugin_present')
  dynamic universalPlugin;
  @JsonKey(name: 'result')
  dynamic downResult;

  AmpDownStreamItem({
    this.downGain,
    this.downSlope,
    this.agcConfig,
    this.universalPlugin,
    this.downResult,
  });

  factory AmpDownStreamItem.fromJson(Map<String, dynamic> json) =>
      _$AmpDownStreamItemFromJson(json);

  Map<String, dynamic> toJson() => _$AmpDownStreamItemToJson(this);

  AmpDownStreamItem.empty();
}

@JsonSerializable()
class AmpUpStreamModel {
  String message;
  AmpUpStreamItem result;

  AmpUpStreamModel({
    required this.message,
    required this.result,
  });

  factory AmpUpStreamModel.fromJson(Map<String, dynamic> json) => _$AmpUpStreamModelFromJson(json);

  Map<String, dynamic> toJson() => _$AmpUpStreamModelToJson(this);
}

@JsonSerializable()
class AmpUpStreamItem {
  @JsonKey(name: 'gain')
  dynamic upGain;
  @JsonKey(name: 'slope')
  dynamic upSlope;
  @JsonKey(name: 'ingress_switch')
  dynamic ingressSwitch;
  @JsonKey(name: 'result')
  dynamic upResult;

  AmpUpStreamItem({
    this.upGain,
    this.upSlope,
    this.ingressSwitch,
    this.upResult,
  });

  factory AmpUpStreamItem.fromJson(Map<String, dynamic> json) => _$AmpUpStreamItemFromJson(json);

  Map<String, dynamic> toJson() => _$AmpUpStreamItemToJson(this);

  AmpUpStreamItem.empty();
}

class DSPointData {
  final double freq;
  final double level;
  final double reference;

  DSPointData({required this.freq, required this.level, required this.reference});
}

@JsonSerializable()
class DSAutoAlignSpectrum {
  dynamic message;
  DSAutoAlignSpectrumItem ?result;

  DSAutoAlignSpectrum({required this.message, required this.result});

  factory DSAutoAlignSpectrum.fromJson(Map<String, dynamic> json) =>
      _$DSAutoAlignSpectrumFromJson(json);

  Map<String, dynamic> toJson() => _$DSAutoAlignSpectrumToJson(this);
  DSAutoAlignSpectrum.empty() ;
}

@JsonSerializable()
class DSAutoAlignSpectrumItem {
  List<dynamic> freq;
  @JsonKey(name: 'spectrum_data')
  List<DSSpectrumData> dsSpectrumData;
  dynamic result;

  DSAutoAlignSpectrumItem({required this.freq, required this.dsSpectrumData, required this.result});

  factory DSAutoAlignSpectrumItem.fromJson(Map<String, dynamic> json) => _$DSAutoAlignSpectrumItemFromJson(json);

  Map<String, dynamic> toJson() => _$DSAutoAlignSpectrumItemToJson(this);
}

@JsonSerializable()
class DSSpectrumData {
  final dynamic frequency;
  final dynamic level;
  final dynamic reference;

  DSSpectrumData({required this.frequency, required this.level, required this.reference});

  factory DSSpectrumData.fromJson(Map<String, dynamic> json) => _$DSSpectrumDataFromJson(json);

  Map<String, dynamic> toJson() => _$DSSpectrumDataToJson(this);
}

