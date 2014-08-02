part of sixstair_view;

class Ball extends Model {
  final double radius;
  final vec.Vector4 color;
  
  Float32List vertices;
  Float32List normals;
  
  Ball(PuzzleView v, this.radius, this.color, {int steps: 30}) : super(v) {
    int capacity = steps * steps;
    vertices = new Float32List(capacity * 3 * 6);
    normals = new Float32List(capacity * 3 * 6);
    
    double latStep = PI / steps;
    double lonStep = latStep * 2;
    
    double lat = -PI / 2.0;
    int pointIdx = 0;
    for (int i = 0; i < steps; ++i) {
      double lon = 0.0;
      for (int j = 0; j < steps; ++j) {
        vec.Vector3 coord1 = coordinate(lat, lon);
        vec.Vector3 coord2 = coordinate(lat, lon + lonStep);
        vec.Vector3 coord3 = coordinate(lat + latStep, lon);
        vec.Vector3 coord4 = coordinate(lat + latStep, lon + lonStep);
        normals.setAll(pointIdx * 3 * 6, coord1.storage);
        normals.setAll(3 + pointIdx * 3 * 6, coord2.storage);
        normals.setAll(6 + pointIdx * 3 * 6, coord3.storage);
        normals.setAll(9 + pointIdx * 3 * 6, coord4.storage);
        normals.setAll(12 + pointIdx * 3 * 6, coord3.storage);
        normals.setAll(15 + pointIdx * 3 * 6, coord2.storage);
        
        coord1.scale(radius);
        coord2.scale(radius);
        coord3.scale(radius);
        coord4.scale(radius);
        
        vertices.setAll(pointIdx * 3 * 6, coord1.storage);
        vertices.setAll(3 + pointIdx * 3 * 6, coord2.storage);
        vertices.setAll(6 + pointIdx * 3 * 6, coord3.storage);
        vertices.setAll(9 + pointIdx * 3 * 6, coord4.storage);
        vertices.setAll(12 + pointIdx * 3 * 6, coord3.storage);
        vertices.setAll(15 + pointIdx * 3 * 6, coord2.storage);
        
        lon += lonStep;
        ++pointIdx;
      }
      lat += latStep;
    }
  }
  
  vec.Vector3 coordinate(num lat, num lon) {
    return new vec.Vector3(sin(lat), cos(lat) * cos(lon), cos(lat) * sin(lon));
  }
  
  void draw() {
    view.objectColor = color;
    super.draw();
  }
}
