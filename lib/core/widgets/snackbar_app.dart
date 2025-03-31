import 'package:get/get.dart';

import '../app_colors.dart';

snackBarError(String msg) {
  return Get.snackbar('Erro', msg,
      backgroundColor: AppColors.error, colorText: AppColors.lightGrey);
}

snackBarSuccess(String msg) {
  return Get.snackbar('Sucesso', msg,
      backgroundColor: AppColors.success, colorText: AppColors.lightGrey);
}

snackBarWarning(String msg) {
  return Get.snackbar('Atenção', msg,
      backgroundColor: AppColors.warning, colorText: AppColors.lightGrey);
}
