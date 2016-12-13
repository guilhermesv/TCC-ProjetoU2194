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

float easing = 0.08;
float[] yMaximo;
int nFrases = 49;
String fraseAtiva = str(int(random(nFrases)))+".svg";
String fraseAtiva2 = str(int(random(nFrases)))+".svg";
String fraseAtiva3 = str(int(random(nFrases)))+".svg";

void setup() {
  //size(800, 800);
  fullScreen();
  //size(1024, 576);

  // VERY IMPORTANT: Allways initialize the library before using it
  RG.init(this);
  RG.ignoreStyles();

  minim = new Minim(this);
  // use the getLineIn method of the Minim object to get an AudioInput
  in = minim.getLineIn();
  
  // camera do eder
  // frame = new Capture(this, 320, 240, "Vimicro USB Camera (Altair)");
  
  // camera computador 
  frame = new Capture(this, 320, 240, "Logitech HD Webcam C270");
  frame.start();
  bd = new Detector( this, 255 );
  
  noFill();
  strokeJoin(ROUND);
  strokeCap(ROUND);
}


void draw() {
  background(0, 0, 255);
  translate(width/2, height/3);

  // Analise dos blobs
   if (frame.available()) {
     frame.read();
   }
   
   // Trata e carrega a imagem da webcam para analise
   //frame.filter(BLUR, 6);
   frame.filter(THRESHOLD, 0.4);
   //image(frame, 0, 0);
   frame.loadPixels();
   
   // Inicia a análise
   bd.imageFindBlobs(frame);
   bd.loadBlobsFeatures();
   
   // Obtendo o valor global da massa e mapeando para o contorno
   int massaGlobal = bd.getGlobalWeight();
   float weight = map(massaGlobal, 0, 40000, 0, 50)+1;
   
   // Obtendo o maior valor de Y
   // Procure os centros, e pega o par de coordenadas do canto C
   bd.findCentroids();
   PVector[] corner = bd.getC();
   
   // Percorre todos os blobs guardando os valores de Y
   // em uma lista
   yMaximo = new float[bd.getBlobsNumber()];
   for (int i = 0; i < bd.getBlobsNumber(); i++) {
     yMaximo[i] = corner[i].y;
     
   }
   
   // se houver registros no Y analisa a lista
   if (yMaximo.length > 0) {
     println(max(yMaximo));
     float y = max(yMaximo);
     // O map de y vai até a altura do frame
     // o 0.75 é pra que na metade do caminho jah
     // se obtenha uma boa legibilidade
     targetComplexidade = map(y, 0, 240, 100, 2)*0.3;
     
     // Cria uma referência para a baixa 
     // complexidade
     if (targetComplexidade > 8) {
       targetComplexidade = 100;
     }
     complexidade += (targetComplexidade - complexidade) * easing;
   }

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