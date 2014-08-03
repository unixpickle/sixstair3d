part of sixstair_view;

class Shaders {
  final gl.RenderingContext context;
  gl.Program program;
  
  gl.Shader vertexShader;
  gl.Shader fragmentShader;
  ShaderAttributes attributes;
  
  gl.UniformLocation _projectionMatrixId;
  gl.UniformLocation _ambientShadeId;
  gl.UniformLocation _lightingDirectionId;
  gl.UniformLocation _lightingShadeId;
  
  Shaders(this.context) {
    _initProgram();
    _bindShaderAttributes();
  }
  
  void dispose() {
    context.deleteProgram(program);
    context.deleteShader(vertexShader);
    context.deleteShader(fragmentShader);
  }
  
  void setProjectionMatrix(vec.Matrix4 mat) {
    assert(mat.storage.length == 0x10);
    context.uniformMatrix4fv(_projectionMatrixId, false, mat.storage);
  }
  
  void setAmbientShade(double shade) {
    context.uniform1f(_ambientShadeId, shade);
  }
  
  void setLightingDirection(vec.Vector3 v) {
    assert(v.storage.length == 3);
    context.uniform3fv(_lightingDirectionId, v.storage);
  }
  
  void setLightingShade(double shade) {
    context.uniform1f(_lightingShadeId, shade);
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
  
  void _bindShaderAttributes() {
    attributes = new ShaderAttributes(context, program);
    
    // bind uniforms
    _projectionMatrixId = context.getUniformLocation(program,
        'projectionMatrix');
    _lightingDirectionId = context.getUniformLocation(program,
        'lightingDirection');
    _lightingShadeId = context.getUniformLocation(program, 'lightingShade');
    _ambientShadeId = context.getUniformLocation(program, 'ambientShade');
  }
}

String _vertexShaderSrc = """
precision mediump float;

attribute vec3 vertexPosition;
attribute vec3 vertexNormal;

uniform float ambientShade;
uniform mat4 modelMatrix;
uniform mat4 projectionMatrix;

uniform vec3 lightingDirection;
uniform float lightingShade;

// forward declaration
varying float fragmentBrightness;

void main(void) {
  gl_Position = projectionMatrix * modelMatrix * vec4(vertexPosition, 1.0);
  vec3 normal = mat3(modelMatrix) * vertexNormal;
  float brightness = max(dot(normal, lightingDirection), 0.0);
  fragmentBrightness = min(ambientShade + lightingShade * brightness, 1.0);
}
""";

String _fragmentShaderSrc = """
precision mediump float;

uniform vec4 objectColor;
varying float fragmentBrightness;

void main(void) {
  gl_FragColor = vec4(objectColor.rgb * fragmentBrightness, objectColor.a);
}
"""; 
