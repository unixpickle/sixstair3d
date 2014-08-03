part of sixstair_animation;

class FlipAnimation extends Animation {
  final AnimateRep rep;
  final double duration;
  double flipStart;
  double flipEnd;
  
  FlipAnimation(this.rep, this.duration) : super();
  
  void setup() {
    flipStart = rep.flipRotation;
    if (rep.isFlipped) {
      flipEnd = 0.0;
    } else {
      flipEnd = 1.0;
    }
  }
  
  void tick(_) {
    double fraction;
    if (totalTime > duration) {
      scheduleMicrotask(cancel);
      fraction = 1.0;
    } else {
      fraction = totalTime / duration;
    }
        
    rep.flipRotation = flipStart + (flipEnd - flipStart) * fraction;
    update();
  }
}
