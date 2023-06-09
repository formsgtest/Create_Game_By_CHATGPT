import 'package:flutter/material.dart';
import 'package:game011/game/Game.dart';
import 'package:game011/main.dart';
import 'pause_button.dart';


// This class represents the pause menu overlay.
class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final SpaceShooterGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pause menu title.
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              'Paused',
              style: TextStyle(
                fontSize: 50.0,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  )
                ],
              ),
            ),
          ),

          // Resume button.
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.resumeEngine();
                gameRef.overlays.remove(PauseMenu.id);
                gameRef.overlays.add(PauseButton.id);
              },
              child: const Text('Resume'),
            ),
          ),

          // Restart button.
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.id);
                gameRef.overlays.add(PauseButton.id);
                // gameRef.reset();
                gameRef.resumeEngine();
              },
              child: const Text('Restart'),
            ),
          ),

          // Exit button.
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.id);
                // gameRef.reset();
                gameRef.resumeEngine();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
              child: const Text('Exit'),
            ),
          ),
        ],
      ),
    );
  }
}