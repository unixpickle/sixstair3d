part of sixstair_view;

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
