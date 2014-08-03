part of sixstair_animation;

class TurnAnimation extends Animation {
  final AnimateRep rep;
  final double duration;
  final bool clockwise;
  
  double topStart;
  double topEnd;
  double bottomStart;
  double bottomEnd;
  List<AnimateBall> balls;
  
  TurnAnimation(this.rep, this.duration, this.clockwise) : super();
  
  void setup() {
    bottomStart = rep.bottomRotation;
    topStart = rep.topRotation;
    double amount = clockwise ? 1/6 : -1/6;
    if (rep.isFlipped) {
      bottomEnd = rep.bottomRotation + amount;
      topEnd = rep.topRotation;
    } else {
      topEnd = rep.topRotation + amount;
      bottomEnd = rep.bottomRotation;
    }
    
    balls = <AnimateBall>[];
    for (AnimateBall ball in rep.balls) {
      if ((ball.y > 0 && !rep.isFlipped) || 
          (ball.y < 0 && rep.isFlipped)) {
        balls.add(ball);
        double scale = rep.isFlipped ? -1.0 : 1.0;
        ball._startRotation = ball.rotation;
        ball._endRotation = ball.rotation + amount * scale;
      }
    }
  }
  
  void tick(_) {
    double fraction;
    if (totalTime >= duration) {
      scheduleMicrotask(cancel);
      fraction = 1.0;
    } else {
      fraction = totalTime / duration;
    }
    
    rep.topRotation = topStart + (topEnd - topStart) * fraction;
    rep.bottomRotation = bottomStart + (bottomEnd - bottomStart) * fraction;
    
    for (AnimateBall ball in balls) {
      ball.rotation = ball._startRotation +
          (ball._endRotation - ball._startRotation) * fraction;
    }
    
    update();
  }
}
