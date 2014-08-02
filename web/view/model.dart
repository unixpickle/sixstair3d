part of sixstair_view;

abstract class Model {
  final PuzzleView view;
  vec.Vector3 position;
  
  gl.Buffer _normalsBuffer;
  gl.Buffer _verticesBuffer;
  gl.Buffer _indicesBuffer;
  
  gl.RenderingContext get context => view.context;
  
  Model(this.view) {
    _normalsBuffer = null;
    _verticesBuffer = null;
    _indicesBuffer = null;
    
    position = new vec.Vector3(0.0, 0.0, 0.0);
  }
  
  void dispose() {
    if (_normalsBuffer != null) {
      context.deleteBuffer(_normalsBuffer);
    }
    if (_verticesBuffer != null) {
      context.deleteBuffer(_verticesBuffer);
    }
    if (_indicesBuffer != null) {
      context.deleteBuffer(_indicesBuffer);
    }
  }
  
  void draw() {    
    vec.Matrix4 oldModel = new vec.Matrix4.copy(view.modelMatrix);
    vec.Matrix4 newModel = new vec.Matrix4.copy(view.modelMatrix);
    
    newModel *= new vec.Matrix4.identity().translate(position.x, position.y,
        position.z);
    
    view.modelMatrix = newModel;
    
    context.bindBuffer(gl.ARRAY_BUFFER, verticesBuffer);
    context.vertexAttribPointer(view._vertexPositionId, 3, gl.FLOAT, false, 0,
        0);
    
    context.bindBuffer(gl.ARRAY_BUFFER, normalsBuffer);
    context.vertexAttribPointer(view._vertexNormalId, 3, gl.FLOAT, false, 0, 0);
    
    if (indicesBuffer != null) {
      context.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indicesBuffer);
    }
    
    if (indices != null) {
      context.drawElements(drawMethod, indices.length, gl.UNSIGNED_SHORT, 0);
    } else {
      context.drawArrays(drawMethod, 0, vertices.length ~/ 3);
    }
    
    view.modelMatrix = oldModel;
  }
  
  int get drawMethod => gl.TRIANGLES;
  
  Float32List get normals;
  Float32List get vertices;
  Uint16List get indices => null;
  
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
  
  gl.Buffer get indicesBuffer {
    if (_indicesBuffer != null) return _indicesBuffer;
    if (indices == null) return null;
    _indicesBuffer = context.createBuffer();
    context.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, _indicesBuffer);
    context.bufferData(gl.ELEMENT_ARRAY_BUFFER, indices, gl.STATIC_DRAW);
    return _indicesBuffer;
  }
  
  gl.Buffer _createFloatBuffer(Float32List l) {
    gl.Buffer buf = context.createBuffer();
    context.bindBuffer(gl.ARRAY_BUFFER, buf);
    context.bufferData(gl.ARRAY_BUFFER, l, gl.STATIC_DRAW);
    return buf;
  }
}
