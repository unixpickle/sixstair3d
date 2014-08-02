part of sixstair_view;

class Ball extends Model {
  final double radius;
  double x;
  double y;
  double z;
  
  Float32List colors;
  Float32List vertices;
  Float32List normals;
  
  Ball(PuzzleView v, this.radius, num steps, vec.Vector4 color) : super(v) {
    x = y = z = 0.0;
    
    int capacity = steps * steps;
    colors = new Float32List(capacity * 4);
    vertices = new Float32List(capacity * 3);
    normals = new Float32List(capacity * 3);
    
    double latStep = PI / steps;
    double lonStep = latStep * 2;
    
    double lat = -PI / 2.0;
    int pointIdx = 0;
    for (int i = 0; i < steps; ++i) {
      double lon = 0.0;
      for (int j = 0; j < steps; ++j) {
        colors.setAll(pointIdx * 4, color.storage);
        
        vec.Vector3 coord = coordinate(lat, lon);
        normals.setAll(pointIdx * 3, coord.storage);
        
        coord.scale(radius);
        vertices.setAll(pointIdx * 3, coord.storage);
        
        lon += lonStep;
        ++pointIdx;
      }
      lat += latStep;
    }
  }
  
  vec.Vector3 coordinate(num lat, num lon) {
    return new vec.Vector3(sin(lat), cos(lat) * cos(lon), cos(lat) * sin(lon));
  }
}
