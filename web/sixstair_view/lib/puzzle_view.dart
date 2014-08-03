part of sixstair_view;

class PuzzleView {
  static const double RADIUS = 1.5;
  static const double BALL_RADIUS = 0.5;
  static const double TUBE_RADIUS = 0.6;
  static const double PUZZLE_Z = -13.0;
  
  final CanvasElement canvas;
  final gl.RenderingContext context;
  Shaders shaders;
  ModelView modelView;
  
  BallModel ball;
  final List<TubeModel> topTubes;
  final List<TubeModel> bottomTubes;
  
  final List<StreamSubscription> _eventSubs;
  double _rotation;
  double _origRotation;
  bool _isPressed;
  double _clickStart;
  
  PuzzleRep puzzleRep;
  
  int get width => canvas.width;
  int get height => canvas.height;
  
  PuzzleView(CanvasElement c) : canvas = c,
      context = c.getContext3d(alpha: true), topTubes = <TubeModel>[],
      bottomTubes = <TubeModel>[], _eventSubs = <StreamSubscription>[] {
    if (context == null) throw new UnsupportedError('WebGL unsupported!');
    shaders = new Shaders(context);
    modelView = new ModelView(context,
        context.getUniformLocation(shaders.program, 'modelMatrix'));
    
    // setup lighting
    shaders.setAmbientShade(0.25);
    double v = sqrt(1.0 / 3.0);
    shaders.setLightingDirection(new vec.Vector3(v, v, v));
    shaders.setLightingShade(0.75);
    
    // setup perspective
    vec.Matrix4 projection = new vec.Matrix4.identity();
    vec.setPerspectiveMatrix(projection, PI / 3, height / width, 0.1, 100);
    shaders.setProjectionMatrix(projection);
    
    // setup objects
    ball = new BallModel(context, BALL_RADIUS);
    ball.position = new vec.Vector3(0.0, 0.0, -10.0);
    _createTubes();
    
    _rotation = 0.0;
    _eventSubs.add(c.onMouseDown.listen(_handleMouseDown));
    _eventSubs.add(c.onMouseMove.listen(_handleMouseMove));
    _eventSubs.add(c.onMouseUp.listen(_handleMouseUp));
    _isPressed = false;
  }
  
  void draw() {
    context.viewport(0, 0, width, height);
    context.clearColor(0.0, 0.0, 0.0, 1.0);
    context.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    
    modelView.pushState();
    modelView.translate(new vec.Vector3(0.0, 0.0, PUZZLE_Z));
    modelView.rotate(new vec.Vector3(0.0, 0.0, 1.0),
            puzzleRep.flipRotation * PI);
    modelView.rotate(new vec.Vector3(0.0, 1.0, 0.0), _rotation);
    
    enableBlend();
    
    modelView.pushState();
    modelView.rotate(new vec.Vector3(0.0, 1.0, 0.0),
        -puzzleRep.topRotation * PI * 2);
    for (TubeModel t in topTubes) {
      t.draw(modelView, shaders.attributes);
    }
    modelView.popState();
    
    modelView.pushState();
    modelView.rotate(new vec.Vector3(0.0, 1.0, 0.0),
            puzzleRep.bottomRotation * PI * 2);
    for (TubeModel t in bottomTubes) {
      t.draw(modelView, shaders.attributes);
    }
    modelView.popState();
    
    enableDepth();

    List<vec.Vector3> ballColors = [new vec.Vector3(0.0, 0.0, 0.0),
                                    new vec.Vector3(1.0, 1.0, 1.0),
                                    new vec.Vector3(0.0, 0.0, 1.0),
                                    new vec.Vector3(1.0, 1.0, 0.0),
                                    new vec.Vector3(0.0, 1.0, 0.0),
                                    new vec.Vector3(1.0, 0.0, 0.0)];
    
    for (BallRep b in puzzleRep.balls) {
      vec.Vector3 color = ballColors[b.color - 1];
      ball.color = new vec.Vector4(min(color.r + 0.1, 1.0),
          min(color.g + 0.1, 1.0), min(color.b + 0.1, 1.0), 1.0);
      ball.position = new vec.Vector3(b.x, b.y, b.z);
      ball.draw(modelView, shaders.attributes);
    }
    
    modelView.popState();
  }
  
  void enableBlend() {
    context.disable(gl.DEPTH_TEST);
    context.enable(gl.BLEND);
    context.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
    context.depthFunc(gl.LESS);
  }
  
  void enableDepth() {
    context.enable(gl.DEPTH_TEST);
    context.disable(gl.BLEND);
  }
  
  void _createTubes() {
    var tubeColor = new vec.Vector4(0.9, 0.9, 1.0, 0.3);
    
    for (int i = 0; i < 6; ++i) {
      double angle = PI * (2/6) * i.toDouble() + PI / 2;
      double height = (i + 1).toDouble() * BALL_RADIUS * 2;
      
      TubeModel t = new TubeModel(context, TUBE_RADIUS, height, true);
      t.position = new vec.Vector3(RADIUS * -cos(angle), 0.0,
          RADIUS * sin(angle));
      t.color = tubeColor;
      topTubes.add(t);
      
      t = new TubeModel(context, TUBE_RADIUS, height, false);
      t.position = new vec.Vector3(RADIUS * -cos(angle), 0.0,
          RADIUS * sin(angle));
      t.color = tubeColor;
      bottomTubes.add(t);
    }
  }
  
  void _handleMouseDown(MouseEvent event) {
    _isPressed = true;
    _origRotation = _rotation;
    _clickStart = event.client.x.toDouble();
  }
  
  void _handleMouseMove(MouseEvent event) {
    if (!_isPressed) return;
    
    double len = (event.client.x - _clickStart).toDouble();
    if (puzzleRep.isFlipped) len *= -1;
    _rotation = (_origRotation + len / 100).toDouble();
    
    draw();
  }
  
  void _handleMouseUp(_) {
    _isPressed = false;
  }
  
}
