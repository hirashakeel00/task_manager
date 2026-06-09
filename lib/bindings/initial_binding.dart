import 'package:get/get.dart';
import 'package:task_manager/controllers/auth_controller.dart';
import '../controllers/task_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TaskController());
    Get.put(AuthController());
  }
}
