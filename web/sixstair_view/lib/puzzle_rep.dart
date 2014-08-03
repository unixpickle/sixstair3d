part of sixstair_view;

class BallRep {
  final int color; // 1 through 6
  double y;
  double _rotation;
  
  double get rotation {
    return _rotation;
  }
  
  void set rotation(double rot) {
    _rotation = rot;
    while (_rotation < 0.0) {
      _rotation += 1.0;
    }
    while (_rotation > 1.0) {
      _rotation -= 1.0;
    }
  }
  
  double get x {
    return cos(rotation * PI * 2) * PuzzleView.RADIUS;
  }
  
  double get z {
    return sin(rotation * PI * 2) * PuzzleView.RADIUS;
  }
  
  int get tubeIndex {
    assert(rotation >= 0 && rotation <= 1);
    return min(max((rotation * 6).round() + 1, 6), 1);
  }
  
  BallRep(this.color) {
    y = 0.0;
    rotation = 0.0;
  }
}

class PuzzleRep {
  final List<BallRep> balls;
  
  double topRotation;
  double bottomRotation;
  double flipRotation;
  
  PuzzleRep() : balls = <BallRep>[] {
    topRotation = 0.0;
    bottomRotation = 0.0;
    flipRotation = 0.0;
    
    // generate the balls
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j <= i; j++) {
        BallRep b = new BallRep(i + 1);
        b.y = -(j * PuzzleView.BALL_RADIUS * 2 + PuzzleView.BALL_RADIUS +
            TubeModel.SPACING + PuzzleView.TUBE_HEIGHT_PADDING);
        b.rotation = -i / 6 + 0.25;
        while (b.rotation > 1) b.rotation -= 1;
        balls.add(b);
      }
    }
  }
}
