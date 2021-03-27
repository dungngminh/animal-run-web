import 'package:flame/components/parallax_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flutter/cupertino.dart';
import 'package:ninja/game_screens/enemy_manager.dart';
import 'package:ninja/utils/enemy.dart';

import '../utils/player.dart';

const double groundHeight = 32;

AnimalRun animalRun = AnimalRun();

class AnimalRun extends BaseGame with TapDetector {
  //player
  Player _player;
  ParallaxComponent _parallaxComponent;
  TextComponent _scoreText;
  int score;
  EnemyManager _enemyManager;

  AnimalRun() {
    _parallaxComponent = ParallaxComponent(
      [
        ParallaxImage('layer1.png'),
        ParallaxImage('layer2.png'),
        ParallaxImage('layer3.png'),
        ParallaxImage('layer4.png'),
        ParallaxImage('layer5.png'),
        ParallaxImage('layer6.png', fill: LayerFill.none),
      ],
      baseSpeed: Offset(100, 0),
      layerDelta: Offset(20, 0),
    );
    _player = Player();
    _enemyManager = EnemyManager();

    //add to screen
    add(_parallaxComponent);
    add(_player);
    add(_enemyManager);

    score = 0;
    _scoreText = TextComponent(score.toString());
    add(_scoreText);
  }
  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
    _player.jump();
  }

  @override
  void onTapUp(TapUpDetails details) {
    super.onTapUp(details);
  }

  @override
  void resize(Size size) {
    super.resize(size);
    _scoreText.setByPosition(Position(
        (size.width / 2) - (_scoreText.width / 2), size.height * 0.05));
  }

  @override
  void update(double t) {
    super.update(t);
    score += (60 * t).toInt();
    _scoreText.text = score.toString();

    components.whereType<Enemy>().forEach((element) {
      if (_player.distance(element) < 60) {
        _player.hit();
      }
    });
  }
}
