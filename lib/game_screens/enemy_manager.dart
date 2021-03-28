import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/time.dart';
import 'package:flutter/material.dart';
import 'package:ninja/game_screens/playscreen.dart';
import 'package:ninja/model/enemy/enemy_type.dart';
import 'package:ninja/utils/enemy.dart';

class EnemyManager extends Component with HasGameRef<AnimalRun> {
  Random _random;
  Timer _timer;
  int _spawnLevel;
  EnemyManager() {
    _random = Random();
    _spawnLevel = 0;
    _timer = Timer(4, repeat: true, callback: () {
      randomEnemy();
    });
    _timer.start();
  }
  void randomEnemy() {
    final randomNumber = _random.nextInt(EnemyType.values.length);
    final randomEnemyType = EnemyType.values.elementAt(randomNumber);
    final newEnemy = Enemy(randomEnemyType);
    gameRef.addLater(newEnemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void render(Canvas c) {}

  @override
  void update(double t) {
    _timer.update(t);

    var newSpawnLevel = (gameRef.score ~/ 500);
    if (_spawnLevel < newSpawnLevel) {
      _spawnLevel = newSpawnLevel;

      var newWaitTime = (4 / (1 + (0.1 * _spawnLevel)));

      _timer.stop();
      _timer = Timer(
        newWaitTime,
        repeat: true,
        callback: () {
          randomEnemy();
        },
      );
      _timer.start();
    }
  }

  void reset() {
    _spawnLevel = 0;
    _timer = Timer(4, repeat: true, callback: () {
      randomEnemy();
    });
  }
}
