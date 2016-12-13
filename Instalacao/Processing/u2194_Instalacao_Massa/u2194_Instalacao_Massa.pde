import geomerative.*;
import ddf.minim.*;
import blobscanner.*;
import processing.video.*;

Minim minim;
AudioInput in;

RShape forma;
RShape polyForma;
RPoint[][] pointPaths;

Detector bd;
Capture frame;

float x, noise, targetComplexidade, blobComplexidade, complexidade;

float easing = 0.05;
int nFrases = 49;
String fraseAtiva = str(int(random(nFrases)))+".svg";
String fraseAtiva2 = str(int(random(nFrases)))+".svg";
String fraseAtiva3 = str(int(random(nFrases)))+".svg";

void setup() {
  //size(800, 800);
  size(1024, 576);

  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  RG.ignoreStyles();

  minim = new Minim(this);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  // camera do eder
  // frame = new Capture(this, 320, 240, "Vimicro USB Camera (Altair)");
  
  // notebook 
  frame = new Capture(this, 320, 240);
  frame.start();
  bd = new Detector( this, 255 );

  stroke(255);
  strokeWeight(5);
  noFill();
  strokeJoin(ROUND);
  strokeCap(ROUND);
}


void draw() {
  background(0, 0, 255);
  translate(width/2, height/3);
  //blobs();

  
  
  // criar um valor destino para X
  targetComplexidade = blobComplexidade;
  // aproxima o valor de X ao do target
  complexidade += (targetComplexidade - complexidade) * easing;

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
  frase(fraseAtiva3, complexidade, pesoBlobs()/2, noise);
  popMatrix();
  
  stroke(255);
  frase(fraseAtiva, complexidade, pesoBlobs(), noise);
  
}