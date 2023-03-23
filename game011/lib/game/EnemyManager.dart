import 'dart:math';
import 'package:flame/components.dart';
import 'Enemy.dart';
import 'Game.dart';

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
