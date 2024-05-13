import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import '../../components/tts/animated_textframe.dart';
import '../../provider/tts/tts_provider.dart';
import '../../provider/user/future_provider.dart';

class TtsPage extends ConsumerWidget {
  final GlobalKey<AnimatedTextFrameState> animatedTextKey = GlobalKey();
  final AudioPlayer player = AudioPlayer();

  TtsPage({super.key}); // Audio player instance

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authTokenAsyncValue = ref.watch(authManagerProvider);
    final String baseUrl =
        dotenv.get("TTS_API_URL"); // Ensure dotenv is initialized before this

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.0),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            child: AnimatedTextFrame(
              key: animatedTextKey,
              onTextTap: () {
                player.stop(); // Stop playback when the text frame is tapped
              },
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0,
            left: 0,
            right: MediaQuery.of(context).size.height * 0.2692,
            child: ElevatedButton(
              onPressed: () => authTokenAsyncValue.when(
                data: (String? token) async {
                  if (token != null) {
                    try {
                      // Fetch new text from API
                      final summaryText =
                          await ref.read(ttsSummaryProvider(token).future);
                      animatedTextKey.currentState?.updateText(
                          summaryText); // Update text on the animated text frame

                      final response = await http.get(
                          Uri.parse('$baseUrl/check'),
                          headers: {'Authorization': 'Bearer $token'});

                      if (response.statusCode == 200) {
                        // Start audio streaming
                        Uri audioUri = Uri.parse('$baseUrl/stream');
                        await player.setAudioSource(AudioSource.uri(audioUri,
                            headers: {'Authorization': 'Bearer $token'}));
                        player.play();
                      } else if (response.statusCode == 429) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('일일 요청 제한에 도달했습니다')));
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("Failed to play audio or fetch text: $e")));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content:
                            Text("Token is null, cannot perform actions.")));
                  }
                },
                error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Token fetching failed: $e"))),
                loading: () => const CircularProgressIndicator(),
              ),
              child: const Text('일정 확인'),
            ),
          ),
        ],
      ),
    );
  }
}
