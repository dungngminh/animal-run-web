import 'package:flame/animation.dart' as ani;
import 'package:flame/components/animation_component.dart';
import 'package:flame/sprite.dart';
import 'package:flame/time.dart';
import 'package:flutter/cupertino.dart';

import 'package:ninja/utils/constants.dart';

class Player extends AnimationComponent {
  ani.Animation _idleAnimation, _runAnimation, _jumpAnimation, _hitAnimation;

  double speedY = 0.0;
  double yMax = 0.0;
  Size _size;
  bool _isHit;
  Timer timer;
  ValueNotifier<int> heart;
  Player() : super.empty() {
    //idle
    List<Sprite> idle = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        .map((e) => Sprite('Idle ($e).png'))
        .toList();
    _idleAnimation = ani.Animation.spriteList(idle, stepTime: 0.05);
    //run
    List<Sprite> run =
        [1, 2, 3, 4, 5, 6, 7, 8].map((e) => Sprite('run ($e).png')).toList();
    _runAnimation = ani.Animation.spriteList(run, stepTime: 0.1);
    //jump
    List<Sprite> jump =
        [2, 3, 4, 5, 6, 7, 8].map((e) => Sprite('Jump ($e).png')).toList();
    _jumpAnimation = ani.Animation.spriteList(jump, stepTime: 0.8);
    //hit
    List<Sprite> hit = [3]
        .map((e) => Sprite('Hurt ($e).png'))
        .toList();
    _hitAnimation = ani.Animation.spriteList(hit, stepTime: 0.1);
    this.animation = _runAnimation;
    heart = ValueNotifier(1);
    _size = Size(0, 0);
    _isHit = false;
    timer = Timer(2, callback: () {
      running();
    });
  }
  @override
  void resize(Size size) {
    super.resize(size);
    this._size = size;
    this.height = this.width = size.width / 12;
    this.x = this.width + 10;
    this.y = size.height - groundHeight - this.height + bottomSpacing;
    this.yMax = this.y;
  }

  @override
  void update(double t) {
    super.update(t);
    this.speedY += GRAVITY * t;

    this.y += this.speedY * t;
    if (isOnGround()) {
      this.y = this.yMax;
      this.speedY = 0;
      running();
    }
    timer.update(t);
  }

  bool isOnGround() {
    return this.y >= this.yMax;
  }

  void hit() {
    if (!_isHit) {
      this.animation = _hitAnimation;
      heart.value -= 1;
      timer.start();
      _isHit = true;
    }
  }

  void running() {
    _isHit = false;
    this.animation = _runAnimation;
  }

  void jump() {
    if (isOnGround()) {
      this.animation = _jumpAnimation;
      this.speedY = -_size.height;
    }
  }
}
