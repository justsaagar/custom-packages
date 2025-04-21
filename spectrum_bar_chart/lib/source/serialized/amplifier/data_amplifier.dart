import 'package:get/get.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_amplifier.g.dart';

@JsonSerializable()
class DsManualAlignmentModel {

  dynamic message;
  @JsonKey(name: 'result')
  DsManualAlignmentItem? result;

  DsManualAlignmentModel({this.message, this.result});

  factory DsManualAlignmentModel.fromJson(Map<String, dynamic> json) =>
      _$DsManualAlignmentModelFromJson(json);

  DsManualAlignmentModel.empty();

  Map<String, dynamic> toJson() => _$DsManualAlignmentModelToJson(this);
}

@JsonSerializable()
class DsManualAlignmentItem {
  @JsonKey(name: "values")
  List<DSManualValues> dsValues = [];

  // samp_auto_alignment_op_e {
  // PRE_TUNE        = 1;
  // COARSE_TUNE     = 2;
  // FINE_TUNE       = 3;
  // FULL_TUNE       = 4; //this includes 1, 2, and 3
  // SAVE            = 5;
  // REVERT          = 6;
  // CSM_CALC        = 7;
  // RSME_CALC       = 8;
  // SAVE_COMPLETE   = 9;
  // }
  @JsonKey(includeToJson: false)
  int? manual_align_ctrl_type_enum;

  @JsonKey(defaultValue: 1, fromJson: _valueFromJson,includeToJson: false)
  int factor = 1;
  @JsonKey(includeFromJson: false,includeToJson: false)
  RxBool isProgressing = false.obs;

  DsManualAlignmentItem(
      this.dsValues, {this.manual_align_ctrl_type_enum,
      });

  DsManualAlignmentItem.empty();

  factory DsManualAlignmentItem.fromJson(Map<String, dynamic> json) => _$DsManualAlignmentItemFromJson(json);

  Map<String, dynamic> toJson() => _$DsManualAlignmentItemToJson(this);

  static dynamic _valueFromJson(dynamic json) {
    if (json is num && json == 0) {
      return 10;
    }
    return json;
  }

  dynamic toJsonWithControlType() {
    var json = toJson();
    if (manual_align_ctrl_type_enum != null) {
      json["manual_align_ctrl_type_enum"] = manual_align_ctrl_type_enum;
    }
    return json;
  }
}

@JsonSerializable()
class DSManualValues {
  //----Manual Alignment----//
  int stage=0;
  @JsonKey(name: "ctrl_type")
  int ctrlType=0;
  @JsonKey(name: "min_val")
  double minVal=0;
  @JsonKey(name: "max_val")
  double maxVal=0;
  double value=0;
  @JsonKey(includeFromJson: false, includeToJson: false)
  double initialValue = 0;

  @JsonKey(defaultValue: true)
  bool? dirty = true;

  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isSelected = false;



  DSManualValues.empty();

  DSManualValues(
      this.stage, this.ctrlType, this.minVal, this.maxVal, this.value,this.dirty){
    initialValue = value;
  }

  factory DSManualValues.fromJson(Map<String, dynamic> json) => _$DSManualValuesFromJson(json);

  Map<String, dynamic> toJson() => _$DSManualValuesToJson(this);

  DSManualValues copy() {
    return DSManualValues(
      stage,
      ctrlType,
      minVal,
      maxVal,
      value,
      dirty,
    )
      ..isSelected = isSelected
      ..initialValue = initialValue;
  }
}
