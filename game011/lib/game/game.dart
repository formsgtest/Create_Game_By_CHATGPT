import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/parallax.dart';
import 'package:hive/hive.dart';
import 'Bullet.dart';
import 'Enemy.dart';
import 'EnemyManager.dart';
import 'Player.dart';

class SpaceShooterGame extends FlameGame
    with HasCollisionDetection, PanDetector, TapDetector {
  bool _isAlreadyLoaded = false;
  late Enemy _enemy;
  late EnemyManager _enemyManager;
  late Player _player;
  late Bullet _bullet;
  late TextComponent _scoreText;
  int _score = 0;
  late TextComponent _playerhealth;
  int _health = 100;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if (!_isAlreadyLoaded) {
      camera.viewport = FixedResolutionViewport(Vector2(360, 640));
      final parallax = await loadParallaxComponent(
        [
          ParallaxImageData('stars1.png'),
        ],
        repeat: ImageRepeat.repeat,
        baseVelocity: Vector2(0, -50),
        velocityMultiplierDelta: Vector2(0, 1.5),
      );
      add(parallax);

      _enemy = Enemy();
      add(_enemy);
      _enemyManager = EnemyManager();
      add(_enemyManager);
      _player = Player();
      _bullet = Bullet();

      add(_bullet);
      add(_player);
      _scoreText = TextComponent(
        text: 'Score: 0',
        position: Vector2(10, 10),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'BungeeInline',
          ),
        ),
      );
      add(_scoreText);

      _playerhealth = TextComponent(
        text: 'Health: 100',
        position: Vector2(10, 30),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'BungeeInline',
          ),
        ),
      );
      add(_playerhealth);
    }
    _isAlreadyLoaded = true;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _player.move(info.delta.game);
  }

  @override
  void update(double dt) {
    super.update(dt);

    _scoreText.text = 'Score: $_score';
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  Future<void> updateScore(int score) async {
    final box = await Hive.openBox('scoreBox');
    _score = score;
    await box.put('score', _score);
  }

  void addScore(int score) async {
    _score += score;
    await updateScore(_score);
  }

//減少血量
  void reduceHealth(int health) {
    _health -= health;
    _playerhealth.text = 'Health: $_health';
  }

  void addHealth(int health) {
    _health += health;
    _playerhealth.text = 'Health: $_health';
  }
}
