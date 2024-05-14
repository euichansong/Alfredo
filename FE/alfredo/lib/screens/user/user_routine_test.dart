import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../api/user/survey_api.dart';

class UserRoutineTestPage extends ConsumerStatefulWidget {
  const UserRoutineTestPage({super.key});

  @override
  _UserRoutineTestPageState createState() => _UserRoutineTestPageState();
}

class _UserRoutineTestPageState extends ConsumerState<UserRoutineTestPage> {
  final List<String> questions = [
    '당신은 아침형 인간이신가요?',
    '당신은 야외활동을 좋아하시나요?',
    '당신은 계획을 촘촘하게 세우시나요?',
    '당신은 정적인 취미를 가지고 계신가요?',
    '당신은 강한 의지를 가지고 계신가요?',
  ];

  final Map<String, int> answers = {};
  int currentQuestionIndex = 0;

  void _submitAnswer(int answer) {
    setState(() {
      answers[questions[currentQuestionIndex]] = answer;
      currentQuestionIndex++;
    });

    if (currentQuestionIndex >= questions.length) {
      _submitSurvey();
    }
  }

  Future<void> _submitSurvey() async {
    await SurveyApi.submitSurvey(answers);
    Navigator.pushReplacementNamed(context, '/survey_save');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Routine Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Center(
        child: currentQuestionIndex < questions.length
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    questions[currentQuestionIndex],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _submitAnswer(0),
                        child: const Text('예'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => _submitAnswer(1),
                        child: const Text('아니오'),
                      ),
                    ],
                  ),
                ],
              )
            : const Text('설문조사 제출 중...'),
      ),
    );
  }
}
