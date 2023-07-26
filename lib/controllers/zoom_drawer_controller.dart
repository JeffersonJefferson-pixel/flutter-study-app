import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_study_app/controllers/auth_controller.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class MyZoomDrawerController extends GetxController {
  final zoomDrawerController = ZoomDrawerController();
  Rxn<User?> user = Rxn();

  @override
  void onReady() {
    user.value = Get.find<AuthController>().getUser();
    super.onReady();
  }

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    update();
  }

  void signOut() {
    Get.find<AuthController>().signOut();
  }

  void signIn() {}

  void website() {
    final Uri websiteLaunchUri =
        Uri(scheme: 'https', path: "https://www.dbestech.com");
    _launch(websiteLaunchUri);
  }

  void facebook() {
    final Uri websiteLaunchUri =
        Uri(scheme: 'https', path: "https://www.facebook.com");
    _launch(websiteLaunchUri);
  }

  void email() {
    final Uri emailLaunchUri =
        Uri(scheme: 'mailto', path: 'pb65435021@gmail.com');
    _launch(emailLaunchUri);
  }

  Future<void> _launch(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'could not launch $url';
    }
  }
}
