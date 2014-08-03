part of sixstair_view;

class PuzzleView {
  final CanvasElement canvas;
  final gl.RenderingContext context;
  Shaders shaders;
  ModelView modelView;
  
  BallModel ball;
  
  int get width => canvas.width;
  int get height => canvas.height;
  
  PuzzleView(CanvasElement c) : canvas = c,
      context = c.getContext3d(alpha: true) {
    shaders = new Shaders(context);    
    modelView = new ModelView(context,
        context.getUniformLocation(shaders.program, 'modelMatrix'));
    
    // setup lighting
    shaders.setAmbientShade(0.25);
    double v = sqrt(1/3);
    shaders.setLightingDirection(new vec.Vector3(v, v, v));
    shaders.setLightingShade(0.75);
    
    // setup perspective
    vec.Matrix4 projection = new vec.Matrix4.identity();
    vec.setPerspectiveMatrix(projection, PI / 3, height / width, 0.1, 100);
    shaders.setProjectionMatrix(projection);
    
    // setup objects
    ball = new BallModel(context, 1);
    ball.color = new vec.Vector4(1.0, 0.0, 0.0, 1.0);
    ball.position = new vec.Vector3(0.0, 0.0, -10.0);
    
    // setup context
    context.enable(gl.DEPTH_TEST);
  }
  
  void draw() {
    context.viewport(0, 0, width, height);
    context.clearColor(0.0, 0.0, 0.0, 1.0);
    context.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    ball.draw(modelView, shaders.attributes);
  }
  
}
