import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'Bullet.dart';
import 'Game.dart';
import 'Player.dart';

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
