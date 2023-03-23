import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'Bullet.dart';
import 'Enemy.dart';
import 'Game.dart';

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
