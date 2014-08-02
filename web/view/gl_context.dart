part of sixstair_view;

class GLContext {
  final CanvasElement canvas;
  final gl.RenderingContext context;
  
  gl.Program program;
  gl.Shader vertexShader;
  gl.Shader fragmentShader;
  
  int _vertexPositionId;
  int _vertexNormalId;
  
  gl.UniformLocation _projectionMatrixId;
  gl.UniformLocation _modelMatrixId;
  gl.UniformLocation _ambientShadeId;
  gl.UniformLocation _lightingDirectionId;
  gl.UniformLocation _lightingShadeId;
  gl.UniformLocation _objectColorId;
  
  vec.Matrix4 _modelMatrix;
  
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
  
  void set ambientShade(double x) {
    context.uniform1f(_ambientShadeId, x);
  }
  
  void set lightingDirection(vec.Vector3 vector) {
    assert(vector.storage.length == 3);
    context.uniform3fv(_lightingDirectionId, vector.storage);
  }
  
  void set lightingShade(double x) {
    context.uniform1f(_lightingShadeId, x);
  }
  
  void set objectColor(vec.Vector4 color) {
    context.uniform4fv(_objectColorId, color.storage);
  }
  
  num get width => canvas.width;
  num get height => canvas.height;
  
  GLContext(CanvasElement c) : canvas = c,
      context = c.getContext3d(alpha: true) {
    context.clearColor(0.0, 0.0, 0.0, 1.0);
    context.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
    
    _initProgram();
    _bindShaderAttributes();
  }
  
  void dispose() {
    context.deleteProgram(program);
    context.deleteShader(vertexShader);
    context.deleteShader(fragmentShader);
  }
  
  void clear() {
    context.viewport(0, 0, width, height);
    context.clearColor(0.0, 0.0, 0.0, 1.0);
    context.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
  }
  
  void enableDepth() {
    context.enable(gl.DEPTH_TEST);
    context.disable(gl.BLEND);
  }
  
  void enableBlend() {
    context.disable(gl.DEPTH_TEST);
    context.enable(gl.BLEND);
    context.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
    context.depthFunc(gl.LESS);
  }
  
  void _initProgram() {
    // load shaders
    fragmentShader = context.createShader(gl.FRAGMENT_SHADER);
    vertexShader = context.createShader(gl.VERTEX_SHADER);
    
    context.shaderSource(fragmentShader, _fragmentShaderSrc);
    context.shaderSource(vertexShader, _vertexShaderSrc);
    
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
    _vertexNormalId = context.getAttribLocation(program, 'vertexNormal');
    context.enableVertexAttribArray(_vertexNormalId);
    
    // bind uniforms
    _projectionMatrixId = context.getUniformLocation(program,
        'projectionMatrix');
    _lightingDirectionId = context.getUniformLocation(program,
        'lightingDirection');
    _lightingShadeId = context.getUniformLocation(program, 'lightingShade');
    _modelMatrixId = context.getUniformLocation(program, 'modelMatrix');
    _ambientShadeId = context.getUniformLocation(program, 'ambientShade');
    _objectColorId = context.getUniformLocation(program, 'objectColor');
  }
}
