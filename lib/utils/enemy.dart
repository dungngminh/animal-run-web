import 'dart:math';

import 'package:flame/anchor.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:ninja/model/enemy/enemy_model.dart';
import 'package:ninja/model/enemy/enemy_type.dart';
import 'package:ninja/utils/constants.dart';

class Enemy extends AnimationComponent {
  EnemyModel _enemyData;
  static Random _random = Random();
  static const Map<EnemyType, EnemyModel> _enemyDetails = {
    EnemyType.Pig:
        EnemyModel('Pig (36x30).png', 36, 30, 16, 1, 0.1, 250, false),
    EnemyType.Bat: EnemyModel('Bat (46x30).png', 46, 30, 7, 1, 0.1, 300, true),
    EnemyType.TeGiac:
        EnemyModel('Tegiac (52x34).png', 52, 34, 6, 1, 0.2, 270, false),
    EnemyType.Slime:
        EnemyModel('Slime (44x30).png', 44, 30, 10, 1, 0.1, 300, false),
    EnemyType.Rock1:
        EnemyModel('Rock1_Run (38x34).png', 38, 34, 14, 1, 0.1, 280, false),
    EnemyType.Rock2:
        EnemyModel('Rock2_Run (32x28).png', 32, 28, 15, 1, 0.1, 290, false),
    EnemyType.Ghost:
        EnemyModel('Ghost (44x30).png', 44, 30, 10, 1, 0.1, 300, true),
  };

  Enemy(EnemyType enemyType) : super.empty() {
    _enemyData = _enemyDetails[enemyType];
    final spriteSheet = SpriteSheet(
      imageName: _enemyData.imgSrc,
      textureWidth: _enemyData.textureWidth,
      textureHeight: _enemyData.textureHeight,
      columns: _enemyData.nColumns,
      rows: _enemyData.nRows,
    );
    this.animation = spriteSheet.createAnimation(0,
        from: 0, to: (_enemyData.nColumns - 1), stepTime: _enemyData.timeSet);
    this.anchor = Anchor.center;
  }
  @override
  void resize(Size size) {
    super.resize(size);
    double scaleFactor = (size.width / 10) / _enemyData.textureWidth;
    this.height = _enemyData.textureHeight * scaleFactor;
    this.width = _enemyData.textureWidth * scaleFactor;
    this.x = size.width + this.width;
    this.y = size.height - groundHeight - (this.height / 2) + 2;

    // if (_enemyData.canFly && _random.nextBool()) {
    //   if (_enemyData.imgSrc == 'Bat (46x30).png')
    //     this.y -= this.height * 2;
    //   else
    //     this.y -= this.height * 1.7;
    // }
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= _enemyData.speed * t;
  }

  @override
  bool destroy() {
    return (this.x < -(this.width));
  }
}
