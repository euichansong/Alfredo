import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controller/routine/routine_controller.dart';

// RoutineController를 위한 Provider 정의
final routineControllerProvider = Provider<RoutineController>((ref) {
  return RoutineController(ref);
});
