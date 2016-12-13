import geomerative.*;
import ddf.minim.*;


Minim minim;
AudioInput in;

RShape forma;
RShape polyForma;
RPoint[][] pointPaths;



float x, noise, targetComplexidade, blobComplexidade, complexidade;

float easing = 0.08;
float[] yMaximo;
int nFrases = 49;
String fraseAtiva = str(int(random(nFrases)))+".svg";
String fraseAtiva2 = str(int(random(nFrases)))+".svg";
String fraseAtiva3 = str(int(random(nFrases)))+".svg";

void setup() {
  //size(800, 600);
  fullScreen();
  //size(1024, 576);

  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  RG.ignoreStyles();

  minim = new Minim(this);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  
  noFill();
  strokeJoin(ROUND);
  strokeCap(ROUND);
}


void draw() {
  background(0, 0, 255);
  translate(width/2, height/3);

  float weight = map(mouseY, 0, height, 0, 50)+1;

  targetComplexidade = map(mouseX, 0, width, 100, 2);
  complexidade += (targetComplexidade - complexidade) * easing;
   
  // Microfone
  float mic = in.left.get(0)*100;
  float targetMic = mic;
  noise += (targetMic - noise) * 0.5;
  
  if (mic > 30) {
    background(255, 0, 0);
    fraseAtiva = str(int(random(nFrases)))+".svg";
    fraseAtiva2 = str(int(random(nFrases)))+".svg";
    fraseAtiva3 = str(int(random(nFrases)))+".svg";
  }
  
  
  
  stroke(255, 0, 0);
  pushMatrix();
  translate(-complexidade, 500);
  scale(5);
  frase(fraseAtiva2, complexidade, 0.4, noise);
  popMatrix();
  pushMatrix();
  translate(complexidade, 200);
  scale(5);
  frase(fraseAtiva3, complexidade, weight, noise);
  popMatrix();
  
  stroke(255);
  frase(fraseAtiva, complexidade, weight, noise);
  
}