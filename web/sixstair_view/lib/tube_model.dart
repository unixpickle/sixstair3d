part of sixstair_view;

class TubeModel extends Model {
  final double radius;
  final double height;

  Float32List vertices;
  Float32List normals;
  
  TubeModel(gl.RenderingContext c, num _radius, num _height, bool top,
      {int steps: 30}) :
      super(c), radius = _radius.toDouble(), height = _height.toDouble() {
    vertices = new Float32List(6 * 3 * steps);
    normals = new Float32List(6 * 3 * steps);
    
    double stepScale = PI * 2 / steps.toDouble();
    double heightOffset = top ? height / 2 + 0.2 : -(height / 2 + 0.2);
    
    // generate the cylinder body
    for (int i = 0; i < steps; ++i) {
      double angle = stepScale * i.toDouble();
      double nextAngle = stepScale * (i + 1).toDouble();
      double angleSin = sin(angle);
      double angleCos = cos(angle);
      double nextAngleSin = sin(nextAngle);
      double nextAngleCos = cos(nextAngle);
      
      vec.Vector3 point1 = new vec.Vector3(angleCos * radius,
          heightOffset + height / 2, angleSin * radius);
      vec.Vector3 point2 = new vec.Vector3(nextAngleCos * radius,
          heightOffset + height / 2, nextAngleSin * radius);
      vec.Vector3 point3 = new vec.Vector3(nextAngleCos * radius,
          heightOffset - height / 2, nextAngleSin * radius);
      vec.Vector3 point4 = new vec.Vector3(angleCos * radius,
          heightOffset - height / 2, angleSin * radius);
      
      vec.Vector3 normal1 = new vec.Vector3(angleCos, 0.0, angleSin);
      vec.Vector3 normal2 = new vec.Vector3(nextAngleCos, 0.0, nextAngleSin);
      
      int idx = i * 18;
      
      vertices.setAll(idx, point1.storage);
      vertices.setAll(3 + idx, point2.storage);
      vertices.setAll(6 + idx, point3.storage);
      vertices.setAll(9 + idx, point1.storage);
      vertices.setAll(12 + idx, point3.storage);
      vertices.setAll(15 + idx, point4.storage);
      
      normals.setAll(idx, normal1.storage);
      normals.setAll(3 + idx, normal2.storage);
      normals.setAll(6 + idx, normal2.storage);
      normals.setAll(9 + idx, normal1.storage);
      normals.setAll(12 + idx, normal2.storage);
      normals.setAll(15 + idx, normal1.storage);
    }
  }
}
