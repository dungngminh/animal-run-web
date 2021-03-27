import 'package:flame/anchor.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:ninja/model/enemy/enemy_model.dart';
import 'package:ninja/model/enemy/enemy_type.dart';
import 'package:ninja/utils/constants.dart';

class Enemy extends AnimationComponent {
  double _speed = 200;
  Size _size = Size(0, 0);
  int textureWidth;
  int textureHeight;
  static const Map<EnemyType, EnemyModel> _enemyDetails = {
    EnemyType.Pig: EnemyModel('Pig (36x30).png', 36, 30, 16, 1, 0.1, 250),
    EnemyType.Tacke: EnemyModel('Tacke (84x38).png', 84, 38, 8, 1, 0.2, 300),
    EnemyType.TeGiac: EnemyModel('Tegiac (52x34).png', 52, 34, 6, 1, 0.2, 270),
    EnemyType.Slime: EnemyModel('Slime (44x30).png', 44, 30, 10, 1, 0.1, 300),
    EnemyType.Rock1:
        EnemyModel('Rock1_Run (38x34).png', 38, 34, 14, 1, 0.1, 280),
    EnemyType.Rock2:
        EnemyModel('Rock2_Run (32x28).png', 32, 28, 15, 1, 0.1, 290),
    EnemyType.Rock3:
        EnemyModel('Rock3_Run (22x18).png', 22, 18, 14, 1, 0.1, 260),
  };

  Enemy(EnemyType enemyType) : super.empty() {
    final enemyData = _enemyDetails[enemyType];
    final spriteSheet = SpriteSheet(
      imageName: enemyData.imgSrc,
      textureWidth: enemyData.textureWidth,
      textureHeight: enemyData.textureHeight,
      columns: enemyData.nColumns,
      rows: enemyData.nRows,
    );
    textureWidth = enemyData.textureWidth;
    textureHeight = enemyData.textureHeight;
    this.animation = spriteSheet.createAnimation(0,
        from: 0, to: (enemyData.nColumns - 1), stepTime: enemyData.timeSet);
    this.anchor = Anchor.center;
  }
  @override
  void resize(Size size) {
    super.resize(size);

    double scaleFactor = (size.width / 11) / textureWidth;
    this._size = size;
    this.height = textureHeight * scaleFactor;
    this.width = textureWidth * scaleFactor;
    this.x = size.width + this.width;
    this.y = size.height - groundHeight - (this.height / 2) + 2;
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= this._speed * t;
  }

  @override
  bool destroy() {
    return (this.x < -(this.width));
  }
}
