import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../api/user/user_api.dart';
import '../../models/user/user.dart';
import 'future_provider.dart';
import '../../models/user/user_update_dto.dart';

final userProvider = FutureProvider.autoDispose<User>((ref) async {
  // authManagerProvider로부터 idToken을 가져오기
  final idToken = await ref.watch(authManagerProvider.future);
  if (idToken == null || idToken.isEmpty) {
    throw Exception('No ID Token found');
  }

  return UserApi().getUserInfo(idToken);
});

final userUpdateProvider =
    FutureProvider.family<void, UserUpdateDto>((ref, userUpdateDto) async {
  final idToken = await ref.watch(authManagerProvider.future);
  if (idToken == null || idToken.isEmpty) {
    throw Exception('No ID Token found');
  }

  await UserApi().updateUser(idToken, userUpdateDto);
  ref.refresh(userProvider);
});

// final nicknameProvider = StateProvider.autoDispose<String>((ref) => '');
// final birthProvider = StateProvider.autoDispose<DateTime?>((ref) => null);
// final answerProvider = StateProvider.autoDispose<String>((ref) => '');
// final googleCalendarUrlProvider = StateProvider.autoDispose<String>((ref) => '');

// final userUpdateProvider = FutureProvider.autoDispose<void>((ref) async {
//   final idToken = await ref.watch(authManagerProvider.future);
//   if (idToken == null || idToken.isEmpty) {
//     throw Exception('No ID Token found');
//   }

  
//   final nickname = ref.read(nicknameProvider);
//   final birth = ref.read(birthProvider);
//   final answer = ref.read(answerProvider);
//   final googleCalendarUrl = ref.read(googleCalendarUrlProvider);

  
//   final userUpdateDto = UserUpdateDto(
//     nickname: nickname,
//     birth: birth,
//     answer: answer,
//     googleCalendarUrl: googleCalendarUrl,
//   );

  
//   await UserApi().updateUser(idToken, userUpdateDto);
//   ref.refresh(userProvider); 
// });