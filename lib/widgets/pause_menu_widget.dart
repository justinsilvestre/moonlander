import 'package:flutter/material.dart';
import 'package:moonlander/main.dart';

const pad10 = Padding(padding: EdgeInsets.only(top: 10));

class PauseMenu extends StatelessWidget {
  const PauseMenu({Key? key, required this.game}) : super(key: key);

  final MoonLanderGame game;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
          child: Container(
        width: 320,
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(
                child: Text(
              'Pause',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black),
            )),
            ElevatedButton(
                onPressed: game.resume,
                child: const Text('Resume')),
            pad10,
            ElevatedButton(
                onPressed: game.restart,
                child: const Text('Restart')),
            pad10,
            ElevatedButton(
                onPressed: game.exit,
                child: const Text('Exit'))
          ],
        ),
      ))
    ]);
  }
}
