part of sixstair_view;

class ModelView {
  final gl.RenderingContext context;
  final gl.UniformLocation uniform;
  final List<vec.Matrix4> _stack;
  vec.Matrix4 _current;
  
  vec.Matrix4 get current => _current;
  
  void set current(vec.Matrix4 mat) {
    _current = mat;
    context.uniformMatrix4fv(uniform, false, mat.storage);
  }
  
  ModelView(this.context, this.uniform)
      : _stack = new List<vec.Matrix4>() {
    current = new vec.Matrix4.identity();
  }
  
  void translate(vec.Vector3 trans) {
    current = _current.translate(trans);
  }
  
  void rotate(vec.Vector3 axis, double angle) {
    current = _current.rotate(axis, angle);
  }
  
  void pushState() {
    _stack.add(current.clone());
  }
  
  void popState() {
    assert(_stack.length > 0);
    current = _stack.last;
    _stack.removeLast();
  }
}
