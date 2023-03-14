import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/particles.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Space Shooter Game',
      home: SpaceShooterGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SpaceShooterGame extends StatefulWidget {
  const SpaceShooterGame({Key? key}) : super(key: key);

  @override
  _SpaceShooterGameState createState() => _SpaceShooterGameState();
}

class _SpaceShooterGameState extends State<SpaceShooterGame> {
  int _selectedIndex = 0;
  List<Widget> _pages = [SelectSpaceship()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Space Shooter Game',
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'main',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_grocery_store_sharp),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class SelectSpaceship extends StatelessWidget {
  const SelectSpaceship({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Start button.
            SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GamePlay(),
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

SpacescapeGame _spacescapeGame = SpacescapeGame();

mixin KnowsGameSize on Component {
  late Vector2 gameSize;

  void onResize(Vector2 newGameSize) {
    gameSize = newGameSize;
  }
}

class GamePlay extends StatelessWidget {
  const GamePlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: GameWidget(
          game: _spacescapeGame,

        ),
      ),
    );
  }
}

class SpacescapeGame extends FlameGame with PanDetector {
  late SpriteSheet spriteSheet;
  late Player _player;
  final bool _isAlreadyLoaded = false;

  @override
  Future<void> onLoad() async {
    // Makes the game use a fixed resolution irrespective of the windows size.
    camera.viewport = FixedResolutionViewport(Vector2(540, 960));

    // Initilize the game world only one time.
    if (!_isAlreadyLoaded) {
      // Loads and caches all the images for later use.
      await images.loadAll([
        'simpleSpace_tilesheet@2.png',
        'freeze.png',
        'icon_plusSmall.png',
        'multi_fire.png',
        'nuke.png',
      ]);

      final stars = await ParallaxComponent.load(
        [ParallaxImageData('stars1.png'), ParallaxImageData('stars2.png')],
        repeat: ImageRepeat.repeat,
        baseVelocity: Vector2(0, -50),
        velocityMultiplierDelta: Vector2(0, 1.5),
      );
      add(stars);

      _player = Player();

      add(_player);


    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _player.move(info.delta.game);
  }
}

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpacescapeGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('ship_H.png');
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 100);
    width = 60;
    height = 70;
    anchor = Anchor.center;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}

class EnemyManager extends Component with HasGameRef<SpacescapeGame> {}

class Enemy extends SpriteComponent with HasGameRef<SpacescapeGame>, KnowsGameSize {}
