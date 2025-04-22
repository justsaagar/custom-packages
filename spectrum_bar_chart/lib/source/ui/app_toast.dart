import 'package:toastification/toastification.dart';
import 'package:spectrum_bar_chart/app_import.dart';

extension AppToast on String {
  void showSuccess(BuildContext context,{double fontSize = 16}) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: AppText(this,style: TextStyle(fontSize: fontSize,fontFamily: 'Notosans')),
      icon: const Icon(Icons.check_circle_rounded),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      boxShadow: highModeShadow,
      showProgressBar: false,
    );
  }

  void showError(BuildContext context, {double fontSize = 16}) {
    toastification.show(
      context: context,
      boxShadow: highModeShadow,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      icon: const Icon(Icons.cancel_rounded),
      title: AppText(this,style:  TextStyle(fontSize: fontSize,fontFamily: 'Notosans'),maxLines: this.length > 35 ? 2 : 1,),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12.0),
      showProgressBar: false,
    );
  }
}
