import 'package:flutter_study_app/controllers/theme_controller.dart';
import 'package:flutter_study_app/service/firebase_storage_service.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => FirebaseStorageService(), fenix: true);
  }
}
