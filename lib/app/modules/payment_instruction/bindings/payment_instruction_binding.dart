import 'package:get/get.dart';

import '../controllers/payment_instruction_controller.dart';

class PaymentInstructionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentInstructionController>(
      () => PaymentInstructionController(),
    );
  }
}
