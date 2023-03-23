import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'Enemy.dart';
import 'Game.dart';

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
