part of sixstair_animation;

class AnimateBall extends BallRep {
  double _startRotation;
  double _endRotation;
  
  AnimateBall(int c) : super(c);
}

class AnimateRep extends PuzzleRep {
  final List<AnimateBall> balls;
  static const double FLIP_DURATION = 0.3;
  static const double TURN_DURATION = 0.3;
  
  Future _animateFuture;
  
  Future get future {
    if (_animateFuture == null) {
      return new Future(() => null);
    } else {
      return _animateFuture;
    }
  }
  
  AnimateRep() : balls = <AnimateBall>[], super();
  
  BallRep createBall(int color) {
    return new AnimateBall(color);
  }
  
  Future animateFlip(Function cb) {
    assert(_animateFuture == null);
    var flip = new FlipAnimation(this, FLIP_DURATION);
    var drop = new DropAnimation(this);
    flip.start(cb);
    drop.start(cb);
    flip.future.then((_) {
      drop.stoppable = true;
    });
    return _animateFuture = drop.future.then((_) {
      _animateFuture = null;
      _roundValues();
    });
  }
  
  Future animateTurn(bool clockwise, Function cb) {
    var turn = new TurnAnimation(this, TURN_DURATION, clockwise);
    turn.start(cb);
    return _animateFuture = turn.future.then((_) {
      var drop = new DropAnimation(this, initVel: 0.6);
      drop.start(cb);
      drop.stoppable = true;
      return drop.future;
    }).then((_) {
      _animateFuture = null;
      _roundValues();
    });
  }
  
  void _roundValues() {
    // after a bunch of animations, we should round our values back to perfect
    // floating points.
    topRotation = topTurns.toDouble() / 6;
    bottomRotation = bottomTurns.toDouble() / 6;
    for (AnimateBall ball in balls) {
      double numIdx = ((ball.y + PuzzleView.BALL_RADIUS) /
          (PuzzleView.BALL_RADIUS * 2)).roundToDouble();
      ball.y = (numIdx - 0.5) * PuzzleView.BALL_RADIUS * 2;
    }
  }
}
