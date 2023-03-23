import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/collisions.dart';
import 'package:flame/parallax.dart';
import 'package:hive/hive.dart';

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

class Player extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceShooterGame> {
  double shootRate = 0.5;
  double lastShootTime = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('ship_H.png');
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 100);
    width = 60;
    height = 70;
    anchor = Anchor.center;
  }

  void shoot() {
    final bullet = Bullet();
    bullet.position = position;
    gameRef.add(bullet);
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  @override
  void update(double dt) {
    super.update(dt);
    lastShootTime += dt;
    if (lastShootTime >= shootRate) {
      lastShootTime = 0;
      shoot();
    }
  }

  @override
  void onMount() {
    super.onMount();
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Enemy) {
      null;
    }
  }
}

class Bullet extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceShooterGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('ship_B.png');

    width = 10;
    height = 10;
    anchor = Anchor.center;
  }

  @override
  void onMount() {
    super.onMount();
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Enemy) {
      gameRef.remove(this);
      gameRef.addScore(10);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.add(Vector2(0, -100 * dt));

    if (position.y < 0) {
      gameRef.remove(this);
    }
  }
}

class EnemyManager extends Component with HasGameRef<SpaceShooterGame> {
  double enemyRate = 0.5;

  double enemySpeed = 100;

  double enemyCreateRate = 0.5;

  @override
  void update(double dt) {
    super.update(dt);
    enemyRate -= dt;
    enemyCreateRate -= dt;
    if (enemyRate <= 0) {
      enemyRate = 0.5;
      enemySpeed += 10;
    }
    if (enemyCreateRate <= 0) {
      enemyCreateRate = 0.5;
      createEnemy();
    }
  }

  void createEnemy() {
    final enemy = Enemy();
    enemy.position = Vector2(
      Random().nextDouble() * gameRef.size.x,
      0,
    );
    gameRef.add(enemy);
  }
}

class Enemy extends SpriteComponent
    with CollisionCallbacks, HasGameRef<SpaceShooterGame> {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('ship_A.png');
    width = 60;
    height = 70;
    anchor = Anchor.center;
  }

  @override
  void onMount() {
    super.onMount();

    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is Bullet) {
      gameRef.remove(this);
    } else if (other is Player) {
      gameRef.remove(this);
      gameRef.reduceHealth(10);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.add(Vector2(0, 100 * dt));

    if (position.y > gameRef.size.y) {
      gameRef.remove(this);
    }
  }
}


