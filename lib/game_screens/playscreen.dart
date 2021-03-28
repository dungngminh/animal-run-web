import 'dart:ui';

import 'package:flame/components/parallax_component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/game/game.dart';
import 'package:flame/game/base_game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ninja/game_screens/enemy_manager.dart';
import 'package:ninja/utils/enemy.dart';

import '../utils/player.dart';

const double groundHeight = 32;

AnimalRun animalRun = AnimalRun();

class AnimalRun extends BaseGame with TapDetector, HasWidgetsOverlay {
  //player
  Player _player;
  ParallaxComponent _parallaxComponent;
  TextComponent _scoreText;
  int score;
  Size _size;
  EnemyManager _enemyManager;

  AnimalRun() {
    //init constructor
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
    //Score
    score = 0;
    _scoreText = TextComponent(
      score.toString(),
      config: TextConfig(
        fontFamily: 'Arcade',
        fontSize: 30,
        color: Colors.white,
      ),
    );

    //Hub pause
    addWidgetOverlay('Pause', _buildUI());
    //add to screen
    add(_parallaxComponent);
    add(_player);
    add(_enemyManager);
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
    this._size = size;
    _scoreText.setByPosition(Position(
        (size.width / 2) - (_scoreText.width / 2.1), size.height * 0.05));
  }

  @override
  void update(double t) {
    super.update(t);
    score += (60 * t).toInt();
    _scoreText.text = score.toString();

    components.whereType<Enemy>().forEach((element) {
      if (_player.distance(element) < 45) {
        _player.hit();
      }
    });
    if (_player.heart.value <= 0) gameOver();
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        this.pauseGame();
        break;
      case AppLifecycleState.paused:
        this.pauseGame();
        break;
      case AppLifecycleState.detached:
        this.pauseGame();
        break;
    }
  }

  Widget _buildUI() {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.pause,
              color: Colors.white,
            ),
            onPressed: () {
              pauseGame();
            },
          ),
          ValueListenableBuilder(
            valueListenable: _player.heart,
            builder: (BuildContext context, value, Widget child) {
              final life = List<Widget>();
              int i = 1;
              life.add(
                Icon(
                  (value >= i) ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              );
              return Row(children: life);
            },
          ),
        ],
      ),
    );
  }

  void pauseGame() {
    pauseEngine();
    addWidgetOverlay('HubPause', _pauseMenu());
  }

  Widget _pauseMenu() {
    return Center(
      child: Material(
        color: Color(0x00000000),
        child: Column(
          children: [
            SizedBox(
              height: _size.height * 0.8 / 2,
            ),
            Text(
              'Pause',
              style: TextStyle(
                fontFamily: 'Arcade',
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              alignment: Alignment.center,
              icon: Icon(
                Icons.play_arrow_rounded,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                resumeGame();
              },
            ),
          ],
        ),
      ),
    );
  }

  void resumeGame() {
    removeWidgetOverlay('HubPause');
    resumeEngine();
  }

  void gameOver() {
    pauseEngine();
    addWidgetOverlay('GameOverHub', _gameOverHub());
  }

  Widget _gameOverHub() {
    return Center(
      child: Material(
        color: Color(0x00000000),
        child: Column(
          children: [
            SizedBox(
              height: _size.height * 0.8 / 2,
            ),
            Text(
              'Game Over',
              style: TextStyle(
                fontFamily: 'Arcade',
                fontSize: 50,
                color: Colors.white,
              ),
            ),
            Text(
              'Your score is $score',
              style: TextStyle(
                fontFamily: 'Arcade',
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            IconButton(
              alignment: Alignment.center,
              icon: Icon(
                Icons.replay,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () {
                replay();
                resumeGame();
                removeWidgetOverlay('GameOverHub');
              },
            ),
          ],
        ),
      ),
    );
  }

  void replay() {
    this.score = 0;
    _player.heart.value = 1;
    _enemyManager.reset();

    components.whereType<Enemy>().forEach((element) {
      this.markToRemove(element);
    });
  }
}
