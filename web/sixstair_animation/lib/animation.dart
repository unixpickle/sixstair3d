part of sixstair_animation;

/**
 * An abstract representation of a puzzle animation.
 */
abstract class Animation {
  final Completer _completer;
  DateTime _start;
  DateTime _lastTick;
  Timer _timer;
  Function _update;
  
  Function get update => _update;
  
  Animation() : _completer = new Completer();
  
  /**
   * The number of seconds since this animation began.
   */
  double get totalTime {
    return new DateTime.now().difference(_start).inMilliseconds / 1000.0;
  }
  
  /**
   * A future which completes when the animation finishes or is cancelled.
   */
  Future get future => _completer.future;
  
  /**
   * `true` if the animation is running, `false` otherwise.
   */
  bool get running => _timer != null;
  
  void start(Function cb, {int msTime: 10}) {
    _update = cb;
    _start = _lastTick = new DateTime.now();
    _timer = new Timer.periodic(new Duration(milliseconds: msTime), _tickCb);
    setup();
  }
  
  /**
   * Stop this animation, completing [future]. You should not call this if the
   * animation has already been completed.
   */
  void cancel() {
    _timer.cancel();
    _timer = null;
    _completer.complete();
  }
  
  /**
   * Override this method for your custom animation code.
   * 
   * The number of seconds since the last tick is passed to [tickTime].
   */
  void tick(double tickTime);
  
  /**
   * Override this method to configure your animation after it has been started.
   */
  void setup() {
  }
  
  void _tickCb(_) {
    DateTime now = new DateTime.now();
    double frame = now.difference(_lastTick).inMilliseconds / 1000.0;
    tick(frame);
  }
}
