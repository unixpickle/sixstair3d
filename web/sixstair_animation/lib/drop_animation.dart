part of sixstair_animation;

class DropAnimation extends Animation {
  static const double DELTA = 0.01;
  
  final AnimateRep rep;
  final double initVel;
  bool stoppable;
  
  double velocity;
  List<List<AnimateBall>> tubes;
  
  DropAnimation(this.rep, {this.initVel: 0.0}) : super() {
    stoppable = false;
  }
  
  void setup() {
    if (rep.isFlipped) {
      velocity = initVel;
    } else {
      velocity = -initVel;
    }
    tubes = _groupBalls();
  }
  
  void tick(double frame) {
    // here is where the magic happens
    double g = -cos(rep.flipRotation * PI);
    bool appliedMotion = false;
    
    velocity += g * frame / 30;
    
    for (int i = 0; i < tubes.length; i++) {
      List<AnimateBall> balls = tubes[i];
      
      int start;
      int step;
      if (g >= 0) {
        start = balls.length - 1;
        step = -1;
      } else {
        start = 0;
        step = 1;
      }
      
      for (int j = start; j < balls.length && j >= 0; j += step) {
        AnimateBall ball = balls[j];
        
        // check if it can move
        double minY = _calculateMinY(i);
        double maxY = _calculateMaxY(i);
        
        if (j > 0) {
          minY = balls[j - 1].y + PuzzleView.BALL_RADIUS * 2;
        }
        if (j + 1 < balls.length) {
          maxY = balls[j + 1].y - PuzzleView.BALL_RADIUS * 2;
        }
        
        if (velocity > 0) {
          if (ball.y + DELTA > maxY) {
            continue;
          }
        } else {
          if (ball.y - DELTA < minY) {
            continue;
          }
        }
        
        appliedMotion = true;
        
        // modify the position
        ball.y += velocity * frame;
        if (velocity > 0 && ball.y > maxY) {
          ball.y = maxY;
        } else if (velocity < 0 && ball.y < minY) {
          ball.y = minY;
        }
      }
    }
    
    if (appliedMotion) {
      update();
    } else if (stoppable) {
      cancel();
    } else {
      velocity = 0.0;
    }
  }
  
  List<List<AnimateBall>> _groupBalls() {
    List<List<AnimateBall>> result = new List<List<AnimateBall>>();
    for (int i = 0; i < 6; i++) {
      result.add(new List<AnimateBall>());
    }
    for (AnimateBall b in rep.balls) {
      result[b.tubeIndex].add(b);
    }
    for (int i = 0; i < 6; i++) {
      result[i].sort((AnimateBall b1, AnimateBall b2) {
        return b1.y.compareTo(b2.y);
      });
    }
    return result;
  }
  
  double _calculateMinY(int tube) {
    int ballCount = [1, 6, 5, 4, 3, 2][(tube + rep.bottomTurns) % 6];
    return -((ballCount - 0.5) * PuzzleView.BALL_RADIUS * 2).toDouble();
  }
  
  double _calculateMaxY(int tube) {
    int ballCount = [1, 6, 5, 4, 3, 2][(tube + (6 - rep.topTurns)) % 6];
    return ((ballCount - 0.5) * PuzzleView.BALL_RADIUS * 2).toDouble();
  }
}
