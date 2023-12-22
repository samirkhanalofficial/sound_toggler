import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sound_mode/permission_handler.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

Future<void> toggleSound() async {
  try {
    RingerModeStatus prevState = await SoundMode.ringerModeStatus;
    if (prevState == RingerModeStatus.vibrate) {
      await SoundMode.setSoundMode(RingerModeStatus.normal);
      FlutterRingtonePlayer.playNotification();
    } else {
      await SoundMode.setSoundMode(RingerModeStatus.vibrate);
      Vibrate.vibrate();
    }
    SystemNavigator.pop();
  } on PlatformException {
    bool isGranted = await PermissionHandler.permissionsGranted ?? false;

    if (!isGranted) {
      // Opens the Do Not Disturb Access settings to grant the access
      await PermissionHandler.openDoNotDisturbSetting();
    }
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  toggleSound();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sound Toggler',
      color: Colors.transparent,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text("Sound mode changed, press ok"),
            ),
            ElevatedButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text("ok")),
          ],
        ),
      ),
    );
  }
}
