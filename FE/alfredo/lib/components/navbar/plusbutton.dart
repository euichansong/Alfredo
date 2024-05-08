import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../screens/routine/routine_create_screen.dart';
import '../../screens/schedule/schedule_create_screen.dart';
import '../../screens/routine/routine_list_screen.dart';
import '../../screens/todo/todo_create_screen.dart';

class PlusButton {
  static void showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.white.withOpacity(0.95),
      builder: (BuildContext context) {
        return Container(
          height: 180,
          margin: const EdgeInsets.only(bottom: 58),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              customListTile(Icons.event_note, '루틴', const Color(0xfff0d2338),
                  context, const RoutineCreateScreen()),
              customListTile(Icons.schedule, '일정', const Color(0xfff0d2338),
                  context, const ScheduleCreateScreen()),
              customListTile(Icons.check_circle_outline, '할 일',
                  const Color(0xfff0d2338), context, const TodoCreateScreen()),
            ],
          ),
        );
      },
    );
  }

  static Widget customListTile(IconData icon, String text, Color color,
      BuildContext context, Widget destination) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => destination));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 10),
            Text(text,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
          ],
        ),
      ),
    );
  }
}
