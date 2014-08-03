part of sixstair_view;

class ShaderAttributes {
  final gl.RenderingContext context;
  int positionAttribute;
  int normalAttribute;
  gl.UniformLocation colorUniform;
  
  ShaderAttributes(this.context, gl.Program program, 
      {String posName: 'vertexPosition', String normName: 'vertexNormal',
       String colorName: 'objectColor'}) {
    positionAttribute = context.getAttribLocation(program, posName);
    context.enableVertexAttribArray(positionAttribute);
    normalAttribute = context.getAttribLocation(program, normName);
    context.enableVertexAttribArray(normalAttribute);
    
    colorUniform = context.getUniformLocation(program, colorName);
  }
}
