// import 'package:ecommerce/common/widgets/loaders/animation_loaders.dart';
// import 'package:ecommerce/utils/constants/colors.dart';
// import 'package:ecommerce/utils/helpers/helper_functions.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class TFullScreenLoader {
//   static void openLoadingDialog(String text, String animation) {
//     showDialog(
//       context: Get.overlayContext!,
//       barrierDismissible: false,
//       builder: (_) => PopScope(
//         canPop: false,
//         child: Container(
//           color: THelperFunctions.isDarkMode(Get.context!)
//               ? TColors.dark
//               : TColors.white,
//           width: double.infinity,
//           height: double.infinity,
//           child: Column(
//             children: [
//               SizedBox(height: 250),
//               TAnimationLoaderWidget(text: text, animation: animation)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   static stopLoading() {
//     Navigator.of(Get.overlayContext!).pop();
//   }
// }
