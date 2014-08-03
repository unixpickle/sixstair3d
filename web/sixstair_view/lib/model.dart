part of sixstair_view;

abstract class Model {
  final gl.RenderingContext context;
  gl.Buffer _normalsBuffer;
  gl.Buffer _verticesBuffer;
  
  // abstract getters
  Float32List get normals;
  Float32List get vertices;
  
  // public changeable attributes
  vec.Vector3 position;
  vec.Vector4 color;
  
  Model(this.context) {
    _normalsBuffer = null;
    _verticesBuffer = null;
    position = new vec.Vector3(0.0, 0.0, 0.0);
  }
  
  // concrete getters
  gl.Buffer get normalsBuffer {
    if (_normalsBuffer != null) return _normalsBuffer;
    _normalsBuffer = _createFloatBuffer(normals);
    return _normalsBuffer;
  }
  
  gl.Buffer get verticesBuffer {
    if (_verticesBuffer != null) return _verticesBuffer;
    _verticesBuffer = _createFloatBuffer(vertices);
    return _verticesBuffer;
  }
  
  // concrete methods
  void dispose() {
    if (_normalsBuffer != null) {
      context.deleteBuffer(_normalsBuffer);
    }
    if (_verticesBuffer != null) {
      context.deleteBuffer(_verticesBuffer);
    }
  }
  
  void draw(ModelView view, ShaderAttributes attrs) {
    vec.Matrix4 newModel = new vec.Matrix4.copy(view.current);
    view.pushState();
    view.translate(position);
    
    context.bindBuffer(gl.ARRAY_BUFFER, verticesBuffer);
    context.vertexAttribPointer(attrs.positionAttribute, 3, gl.FLOAT, false, 0,
        0);
    
    context.bindBuffer(gl.ARRAY_BUFFER, normalsBuffer);
    context.vertexAttribPointer(attrs.normalAttribute, 3, gl.FLOAT, false, 0,
        0);
    
    context.uniform4fv(attrs.colorUniform, color.storage);
    
    context.drawArrays(gl.TRIANGLES, 0, vertices.length ~/ 3);
    
    view.popState();
  }
  
  // private generator
  gl.Buffer _createFloatBuffer(Float32List l) {
    gl.Buffer buf = context.createBuffer();
    context.bindBuffer(gl.ARRAY_BUFFER, buf);
    context.bufferData(gl.ARRAY_BUFFER, l, gl.STATIC_DRAW);
    return buf;
  }
}
