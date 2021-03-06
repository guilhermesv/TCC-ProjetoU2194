// Gerador de frase
void frase(String svg, float complexidade, float peso, float ruido) {
  forma = RG.loadShape(svg);
  forma.centerIn(g, 40, 1, 1); // não sei, margem, escala, não sei

  // Configura o geomerative para o efeito polygonize e cria uma nova forma
  // redesenhada
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(complexidade);
  polyForma = RG.polygonize(forma);

  strokeWeight(peso);
  // analisa os pontos presentes na forma
  pointPaths = polyForma.getPointsInPaths();
  for (int i = 0; i<pointPaths.length; i++) { 
    if (pointPaths[i] != null) {
      float pulse = noise(frameCount+i)*0;
      beginShape();
      for (int j = 0; j<pointPaths[i].length; j++) {
        vertex(pointPaths[i][j].x+random(-ruido, ruido), pointPaths[i][j].y+pulse);
      }
      endShape();
    }
  }
}