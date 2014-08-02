part of sixstair_view;

class PuzzleView {
  final CanvasElement canvas;
  final gl.RenderingContext context;
  
  gl.Program program;
  
  int _vertexPositionId;
  int _vertexColorId;
  int _vertexNormalId;
  
  gl.UniformLocation _projectionMatrixId;
  gl.UniformLocation _modelMatrixId;
  gl.UniformLocation _normalMatrixId;
  gl.UniformLocation _ambientShadeId;
  gl.UniformLocation _lightingDirectionId;
  
  vec.Matrix3 _normalMatrix;
  vec.Matrix4 _modelMatrix;
  
  vec.Matrix3 get normalMatrix => _normalMatrix;
  vec.Matrix4 get modelMatrix => _modelMatrix;
  
  void set projectionMatrix(vec.Matrix4 mat) {
    assert(mat.storage.length == 0x10);
    context.uniformMatrix4fv(_projectionMatrixId, false, mat.storage);
  }
  
  void set modelMatrix(vec.Matrix4 mat) {
    assert(mat.storage.length == 0x10);
    _modelMatrix = mat;
    context.uniformMatrix4fv(_modelMatrixId, false, mat.storage);
  }
  
  void set normalMatrix(vec.Matrix3 mat) {
    assert(mat.storage.length == 9);
    _normalMatrix = mat;
    context.uniformMatrix3fv(_normalMatrixId, false, mat.storage);
  }
  
  void set ambientShade(double x) {
    context.uniform1f(_ambientShadeId, x);
  }
  
  void set lightingDirection(vec.Vector3 vector) {
    assert(vector.storage.length == 3);
    context.uniform3fv(_lightingDirectionId, vector.storage);
  }
  
  num get width => canvas.width;
  num get height => canvas.height;
  
  PuzzleView(CanvasElement c) : canvas = c, context = c.getContext3d() {
    context.clearColor(0.0, 0.0, 0.0, 1.0);
    context.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    context.enable(gl.DEPTH_TEST);
    
    _initProgram();
    _bindShaderAttributes();
    
    vec.Matrix4 projection = new vec.Matrix4.identity();
    vec.setPerspectiveMatrix(projection, PI / 2, height / width, -0.1, -100);
    projectionMatrix = projection;
    
    modelMatrix = new vec.Matrix4.identity();
    normalMatrix = new vec.Matrix3.identity();
    ambientShade = 0.3;
    lightingDirection = new vec.Vector3(-1.0, -1.0, -3.0);
  }
  
  void draw() {
    context.viewport(0, 0, width, height);
    context.clearColor(0, 0.5, 0, 1);
    context.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    
    var ball = new Ball(this, 2.0, 10, new vec.Vector4(1.0, 0.0, 0.0, 1.0));
    ball.position = new vec.Vector3(0.0, 0.0, -5.0);
    ball.draw();
    ball.dispose();
  }
  
  void _initProgram() {
    // load shaders
    gl.Shader fragmentShader = context.createShader(gl.FRAGMENT_SHADER);
    gl.Shader vertexShader = context.createShader(gl.VERTEX_SHADER);
    
    ScriptElement script = querySelector('#shader-fs');
    context.shaderSource(fragmentShader, script.text);
    script = querySelector('#shader-vs');
    context.shaderSource(vertexShader, script.text);
    
    context.compileShader(fragmentShader);
    if (!context.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)) {
      window.alert('Failed to compile fragment shader');
      throw new Error();
    }
    context.compileShader(vertexShader);
    if (!context.getShaderParameter(vertexShader, gl.COMPILE_STATUS)) {
      context.deleteShader(fragmentShader);
      window.alert('Failed to compile vertex shader');
      throw new Error();
    }
    
    // create GL program
    program = context.createProgram();
    context.attachShader(program, fragmentShader);
    context.attachShader(program, vertexShader);
    context.linkProgram(program);
    
    if (!context.getProgramParameter(program, gl.LINK_STATUS)) {
      context.deleteShader(fragmentShader);
      context.deleteShader(vertexShader);
      window.alert("Failed to link program");
      throw new Error();
    }
    
    context.useProgram(program);
  }
  
  _bindShaderAttributes() {
    // bind vertex attributes
    _vertexPositionId = context.getAttribLocation(program, 'vertexPosition');
    context.enableVertexAttribArray(_vertexPositionId);
    _vertexColorId = context.getAttribLocation(program, 'vertexColor');
    context.enableVertexAttribArray(_vertexColorId);
    _vertexNormalId = context.getAttribLocation(program, 'vertexNormal');
    context.enableVertexAttribArray(_vertexNormalId);
    
    // bind uniforms
    _projectionMatrixId = context.getUniformLocation(program,
        'projectionMatrix');
    _lightingDirectionId = context.getUniformLocation(program,
        'lightingDirection');
    _modelMatrixId = context.getUniformLocation(program, 'modelMatrix');
    _normalMatrixId = context.getUniformLocation(program, 'normalMatrix');
    _ambientShadeId = context.getUniformLocation(program, 'ambientShade');
  }
  
}
