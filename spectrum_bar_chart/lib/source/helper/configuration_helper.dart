

// configuration_helper.dart
import 'package:spectrum_bar_chart/source/helper/enum_helper.dart';

class AmplifierConfigurationHelper {
  ApiStatus _spectrumApiStatus;

  AmplifierConfigurationHelper(this._spectrumApiStatus);

  ApiStatus get spectrumApiStatus => _spectrumApiStatus;

  set spectrumApiStatus(ApiStatus status) {
    _spectrumApiStatus = status;
  }
}