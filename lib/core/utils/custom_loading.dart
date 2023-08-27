import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  static Future<void> show() async {
    EasyLoading.instance
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..userInteractions = true
      ..dismissOnTap = false;

    await EasyLoading.show(
      status: 'Please wait!',
      maskType: EasyLoadingMaskType.black,
    );
  }

  static void hide() {
    EasyLoading.dismiss();
  }
}
