// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import '../screens/mainpage/main_page.dart';
// import '../screens/user/user_routine_test.dart';

// class CustomNavBar extends StatelessWidget {
//   final PersistentTabController _controller =
//       PersistentTabController(initialIndex: 0);

//   @override
//   Widget build(BuildContext context) {
//     return PersistentTabView(
//       context,
//       controller: _controller,
//       screens: _buildScreens(),
//       items: _navBarsItems(),
//       // ... 나머지 설정 ...
//     );
//   }

//   List<Widget> _buildScreens() {
//     return [
//       MainPage(),
//       UserRoutineTestPage(),
//       // Screen3(),
//     ];
//   }

//   List<PersistentBottomNavBarItem> _navBarsItems() {
//     // ... 네비게이션 바 아이템 설정 ...
//   }
// }
