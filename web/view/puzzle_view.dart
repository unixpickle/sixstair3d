part of sixstair_view;

class PuzzleView extends GLContext {
  List<StreamSubscription> subs;
  bool isPressed;
  
  vec.Matrix4 lastRotation;
  Point clickStart;
  
  PuzzleView(CanvasElement c) : super(c) {
    vec.Matrix4 projection = new vec.Matrix4.identity();
    vec.setPerspectiveMatrix(projection, PI / 3, height / width, 0.1, 100);
    projectionMatrix = projection;
    
    lastRotation = new vec.Matrix4.identity();
    modelMatrix = lastRotation;
    
    ambientShade = 0.25;
    lightingDirection = new vec.Vector3(1.0, 1.0, 1.0);
    lightingShade = 0.75;
    
    subs = [];
    subs.add(c.onMouseDown.listen(handleMouseDown));
    subs.add(c.onMouseMove.listen(handleMouseMove));
    subs.add(c.onMouseUp.listen(handleMouseUp));
    isPressed = false;
  }
  
  void dispose() {
    super.dispose();
    for (StreamSubscription s in subs) {
      s.cancel();
    }
  }
  
  void draw() {
    clear();
    
    var puzzle = new Puzzle(this);
    puzzle.draw();
  }
  
  void handleMouseDown(MouseEvent event) {
    isPressed = true;
    clickStart = event.client;
  }
  
  void handleMouseMove(MouseEvent event) {
    if (!isPressed) return;
    
    Point diff = event.client - clickStart;
    var ortho = new vec.Vector3(-diff.y.toDouble(), diff.x.toDouble(), 0.0);
    double len = sqrt(ortho.dot(ortho));
    ortho.normalize();
    
    var rotation = new vec.Matrix4.identity().rotate(ortho, len / 100.0);
    modelMatrix = lastRotation * rotation;
    draw();
  }
  
  void handleMouseUp(_) {
    isPressed = false;
    lastRotation = modelMatrix;
  }
  
}
