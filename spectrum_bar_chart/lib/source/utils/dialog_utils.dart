import 'package:spectrum_bar_chart/app_import.dart';

class DialogUtils {

  confirmationDialog(
      context,
      String title,
      String description,
      String btnSubmitTitle,
      String btnCancelTitle,
      VoidCallback? onSubmitPressed,
      VoidCallback? onCancelPressed,
      ) {
    return showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          surfaceTintColor: AppColorConstants.colorWhite,
          backgroundColor: AppColorConstants.colorWhite,
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          actionsPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Padding(
            padding:
            const EdgeInsets.only(left: 24, top: 20, right: 24, bottom: 5),
            child: Row(
              children: [
                Icon(
                  size: 24,
                  Icons.info,
                  color: AppColorConstants.colorAppbar,
                ),
                SizedBox(
                  width: getSize(18),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        style: TextStyle(
                            color: AppColorConstants.colorAppbar,
                            fontWeight: FontWeight.w700,
                            fontSize: getSize(20),
                            fontFamily: AppAssetsConstants.openSans),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close)),
              ],
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(left: 24, top: 8, right: 24, bottom: 14),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                description,
                style: TextStyle(
                    color: AppColorConstants.colorAppbar,
                    fontSize: getSize(14),
                    fontFamily: AppAssetsConstants.openSans),
              ),
            ),
          ),
          actions: [
            Container(
              color: AppColorConstants.colorWhiteShade,
              child: Row(
                children: [
                  const Spacer(),
                  Container(
                    padding:
                    const EdgeInsets.only(left: 16, bottom: 16, top: 10),
                    child: AppButton(
                      fontSize: 14,
                      buttonWidth: 45,
                      buttonHeight: 30,
                      fontFamily: AppAssetsConstants.openSans,
                      buttonName: btnCancelTitle,
                      fontColor: AppColorConstants.colorBlackBlue,
                      onPressed: (onCancelPressed != null)
                          ? onCancelPressed
                          : () {
                              Navigator.pop(context);
                            },
                      borderColor: AppColorConstants.colorBackgroundDark,
                      buttonColor: AppColorConstants.colorWhite1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, bottom: 16, top: 8),
                    child: AppButton(
                      fontSize: 14,
                      buttonWidth: 45,
                      buttonHeight: 30,
                      fontFamily: AppAssetsConstants.openSans,
                      buttonName: btnSubmitTitle,
                      onPressed: onSubmitPressed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

}
