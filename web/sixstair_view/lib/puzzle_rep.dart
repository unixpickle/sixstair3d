part of sixstair_view;

double _boundInsideOne(double x) {
  // TODO: see about floating point modulus operator
  while (x < 0) x += 1;
  while (x > 1) x -= 1;
  return x;
}

class BallRep {
  final int color; // 1 through 6
  double y;
  double _rotation;
  
  double get rotation {
    return _rotation;
  }
  
  void set rotation(double rot) {
    _rotation = _boundInsideOne(rot);
  }
  
  double get x {
    return cos(rotation * PI * 2) * PuzzleView.RADIUS;
  }
  
  double get z {
    return sin(rotation * PI * 2) * PuzzleView.RADIUS;
  }
  
  int get tubeIndex {
    assert(rotation >= 0 && rotation <= 1);
    return ((rotation - 0.25) * 6).round() % 6;
  }
  
  BallRep(this.color) {
    y = 0.0;
    rotation = 0.0;
  }
}

abstract class PuzzleRep {
  List<BallRep> get balls;
  
  double _topRotation;
  double _bottomRotation;
  double _flipRotation;
  
  double get topRotation => _topRotation;
  double get bottomRotation => _bottomRotation;
  double get flipRotation => _flipRotation;
  
  void set topRotation(double rot) {
    _topRotation = _boundInsideOne(rot);
  }
  
  void set bottomRotation(double rot) {
    _bottomRotation = _boundInsideOne(rot);
  }
  
  void set flipRotation(double rot) {
    _flipRotation = _boundInsideOne(rot);
  }
  
  int get topTurns => max(min((topRotation * 6).round(), 6), 0).toInt() % 6;
  
  int get bottomTurns {
    return max(min((bottomRotation * 6).round(), 6), 0).toInt() % 6;
  }
  
  bool get isFlipped => flipRotation > 0.5;
  
  PuzzleRep() {
    topRotation = 0.0;
    bottomRotation = 0.0;
    flipRotation = 0.0;
    
    // generate the balls
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j <= i; j++) {
        BallRep b = createBall(i + 1);
        b.y = -(j * PuzzleView.BALL_RADIUS * 2 + PuzzleView.BALL_RADIUS);
        b.rotation = -i / 6 + 0.25;
        balls.add(b);
      }
    }
  }
  
  BallRep createBall(int color) {
    return new BallRep(color);
  }
}
