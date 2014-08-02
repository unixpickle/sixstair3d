part of sixstair_view;

class Puzzle {
  PuzzleView view;
  final List<Tube> topTubes;
  final List<Tube> bottomTubes;
  final List<Ball> balls;
  
  Puzzle(this.view) : topTubes = <Tube>[], bottomTubes = <Tube>[],
      balls = <Ball>[]{
    var tubeColor = new vec.Vector4(0.9, 0.9, 1.0, 0.3);
    List<vec.Vector4> ballColors = [new vec.Vector4(0.0, 0.0, 0.0, 1.0),
                                    new vec.Vector4(1.0, 1.0, 1.0, 1.0),
                                    new vec.Vector4(0.0, 0.0, 1.0, 1.0),
                                    new vec.Vector4(1.0, 1.0, 0.0, 1.0),
                                    new vec.Vector4(0.0, 1.0, 0.0, 1.0),
                                    new vec.Vector4(1.0, 0.0, 0.0, 1.0)];
    
    double radius = 1.5;
    double gap = 0.2;
    for (int i = 0; i < 6; ++i) {
      double angle = PI * (2/6) * i.toDouble() + PI / 2;
      double height = i.toDouble() + 1.2;
      Tube t = new Tube(view, 0.6, height, true, tubeColor, steps: 30);
      t.position = new vec.Vector3(radius * -cos(angle), gap + height / 2,
          radius * sin(angle));
      topTubes.add(t);
      
      t = new Tube(view, 0.6, height, true, tubeColor, steps: 30);
      t.position = new vec.Vector3(radius * -cos(angle), -gap - height / 2,
          radius * sin(angle));
      bottomTubes.add(t);
      
      for (int j = 0; j <= i; j++) {
        Ball b = new Ball(view, 0.5, ballColors[i] * 0.7);
        b.position = new vec.Vector3((radius + 0.05) * -cos(angle),
            -gap - 0.6 - (j.toDouble() * 1.0), (radius + 0.05) * sin(angle));
        balls.add(b);
      }
    }
  }
  
  void draw() {
    vec.Matrix4 oldModel = new vec.Matrix4.copy(view.modelMatrix);
    vec.Matrix4 newModel = new vec.Matrix4.copy(view.modelMatrix);
    
    newModel = new vec.Matrix4.identity().translate(0.0, 0.0, -13.0) * newModel;
    
    view.modelMatrix = newModel;
    
    topTubes.sort((Tube t1, Tube t2) {
      if (t1.position.z < t2.position.z) return -1;
      else if (t1.position.z > t2.position.z) return 1;
      return 0;
    });
    bottomTubes.sort((Tube t1, Tube t2) {
      if (t1.position.z < t2.position.z) return -1;
      else if (t1.position.z > t2.position.z) return 1;
      return 0;
    });
    
    view.enableBlend();
    for (Tube t in topTubes) {
      t.draw();
    }
    for (Tube t in bottomTubes) {
      t.draw();
    }
    
    view.enableDepth();
    for (Ball b in balls) {
      b.draw();
    }
    
    view.modelMatrix = oldModel;
  }
  
  void dispose() {
    for (Tube t in topTubes) {
      t.dispose();
    }
    for (Tube t in bottomTubes) {
      t.dispose();
    }
    for (Ball b in balls) {
      b.dispose();
    }
  }
}