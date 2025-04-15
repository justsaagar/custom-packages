import 'package:json_annotation/json_annotation.dart';

part 'amplifier_configuration.g.dart';




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

