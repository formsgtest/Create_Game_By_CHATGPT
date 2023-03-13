import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/collisions.dart';
import 'package:flame/parallax.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(game: SpaceShooterGame()),
      ),
    ),
  );
}


class SpaceShooterGame extends FlameGame
    with PanDetector, HasGameRef<SpaceShooterGame>, HasCollisionDetection {
  late Player player;
  late Enemy enemy;


  @override
  Future<void> onLoad() async {
    await super.onLoad();
    player = Player();
    enemy = Enemy();
    add(enemy);
    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }

  @override
  void update(double dt) {
    super.update(dt);
    enemy.position.add(Vector2(0, 100 * dt));
    if (enemy.position.y > gameRef.size.y) {
      enemy.position.y = 0;
    }
  }


}

class Player extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  late ShapeHitbox hitbox;
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('player.png');
    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 100);
    width = 60;
    height = 70;
    anchor = Anchor.center;
    add(hitbox);
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
  
  @override
  void onCollision(intersectionPoints, other) {
    if (other is Enemy) {
      print('collision');
    }
  }
}

class Enemy extends SpriteComponent
    with HasGameRef<SpaceShooterGame>, CollisionCallbacks {
  
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('enemy.png');
    position = Vector2(gameRef.size.x / 2, 100);
    width = 60;
    height = 70;
    anchor = Anchor.center;
    
  }
  

}

