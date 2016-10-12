//import codeanticode.syphon.*;

//SyphonServer server;
//import netP5.*;
import java.io.File;
import gifAnimation.*;

//import processing.opengl.*; 
ArrayList<Particle> particlesT;
ArrayList<Particle> particlesB;
int numLines = 100;
PVector mouse;
int d = 1;

int angStart = 180;
float angInc = PI/numLines;
int r = 600;
int sep = 50;


PVector[] windowPoints=new PVector[4];
PVector[] RGBPoints=new PVector[4];
PVector[] IRPoints=new PVector[4];
PVector TPoint=new PVector(0, 0);
PImage src;
PImage stage;
ArrayList<PVector> multiPoints;
boolean IR;
boolean begin;
PVector[] drops=new PVector[5];

int thresholdA;
int IRdepth;
//boolean sketchFullScreen() 
//{  
//  return true;
//}

// these variables store mouse position and change in mouse position along each axis
int xChange = 0;
int yChange = 0;
int lastMouseX = 0;
int lastMouseY = 0;

int numSamples = 0; // how many samples are being loaded?
int sampleWidth = 0; // how much space will a sample take on screen? how wide will be the invisible trigger area?
String sourceFile[]; // an array that will contain our sample filenames

int SWARM_OFFSET = 50;
int MAX_FLIES = 500;
int numFlies = 0;
Fly[] flies = new Fly[MAX_FLIES];
Gif loopingGif;








// these objects allow us to add a delay effect



void setup() {

  IRdepth=1000;
  IR=false;
  begin=false;
  //frameRate(60);
  chessboard= new Chessboard();
  //ripples=new ArrayList<Ripple>();
  thresholdA=250;
  noStroke();
  multiPoints=new ArrayList<PVector>();
  size(1024, 768, P3D);
  // server = new SyphonServer(this, "Processing Syphon");
  src = new PImage(1024, 768); 

  kinect= new Kinect(this);
  windowPointset();
  //aft=new AFT(RGBPoints, windowPoints);
  aftIR=new AFT(IRPoints, RGBPoints);
  //setupBox2D();
  particlesT = new ArrayList<Particle>();
  particlesB = new ArrayList<Particle>();
  for (int i = 0; i < 2*numLines; i++) {
    float angle = angStart + angInc*i ;
    particlesT.add(new Particle(new PVector((r-sep)*cos(angle), (r-sep)*sin(angle))));
    particlesB.add(new Particle(new PVector((r-sep)*cos(angle + PI), (r-sep)*sin(angle + PI))));
  }
  loopingGif = new Gif(this, "flyGIF.gif");
  loopingGif.loop();
  addFly();
  
  //initialize vectors
  
  for (int i=0;i<5;i++){
   drops[i]=new PVector(-1,-1); 
  }
}

void draw() {
  //server.sendScreen();
  clear_cache();
  kinect.update();
  src.copy(kinect.RGBImg(), 0, 0, 1024, 768, 0, 0, 1024, 768);
  if (IR==false) {
    colorMode(RGB);
    background(255);
    //chessboard.DrawChessBoard(10, 7);
    kinect.drawBlob(RGBPoints);
  }
  for (int i=0; i < numFlies; i++) {
    if (!flies[i].isAtTarget()) {
      flies[i].move();
    }
    flies[i].swarm();
    flies[i].paint();
  }

  pushMatrix();
  IRPointsSet();

  if (IR==true) {
    aftIR.ProjectiveTransform();
    background(255);
    kinect.drawBlob(RGBPoints);
  } else if (IR==false) {

    if (begin==true) {
      showPoints(RGBPoints);
      // println("11");
    }
  }
  popMatrix();


  if (IR==false) {
    fill(255, 0, 0);
    text("touchPoint X="+drops[0].x, 10, 20);
    text("touchPoint Y="+drops[0].y, 10, 40);
    text("IR ="+IR, 10, 60);
  } else if (IR==true) {
    //drawBox2D();
    interactive();
  }
  
  //TODO this suppose to have a catch up stage , would be added later
  for (int j=0; j < numFlies; j++) {
    int jump=int(random(5));
    if (drops[jump].x!=-1){
    flies[j].catch_near();
    }
  }
  
  pushMatrix();
  translate(width/2, height/2);
  //mouse = new PVector(drops[0].x - width/2, drops - height/2);

  //  for (Particle p : particlesT) {
  //    PVector force = p.calcForce(mouse, d);
  //    p.applyForce(force);
  //    p.update();
  //  }
  //
  //  for (Particle p : particlesB) {
  //    PVector force = p.calcForce(mouse, d);
  //    p.applyForce(force);
  //    p.update();
  //  }
  noFill();
  strokeWeight(random(2, 5));
  //  for (int i = 0; i < numLines; i++) {
  //    Particle pT = particlesT.get(i);
  //    Particle pB = particlesB.get(i);
  //    float angle = angStart + angInc*i;
  //    stroke(255 - i, 150 - i, 10, 70);
  //    bezier(r*cos(angle), r*sin(angle), pT.location.x, pT.location.y, pB.location.x, pB.location.y, r*cos(angle + PI), r*sin(angle + PI));
  //  }

  popMatrix();
  lights();
  translate(width/2, height/2);
  rotateX(frameCount * 0.01);
  rotateY(frameCount * 0.01);  
  //box(150);
}

void windowPointset() {
  windowPoints[3]=new PVector(1024/10*9, 768/7*6);//00
  windowPoints[2]=new PVector(1024/10, 768/7*6);  //10
  windowPoints[1]=new PVector(1024/10, 768/7);    //11
  windowPoints[0]=new PVector(1024/10*9, 768/7);  //01
}

void showPoints(PVector[] points) {
  PVector[] pp=new PVector[4];
  pp=points;
  noStroke();
  fill(255, 0, 0);
  for (int i=0; i<4; ++i) {
    ellipse(pp[i].x, pp[i].y, 10, 10);
    text("p"+i+"("+pp[i].x+","+pp[i].y+")", pp[i].x, pp[i].y);
  }
}

void interactive() {
  //background(0);
  //  for (int i=0;i<ripples.size();i++) {
  //    Ripple rp=ripples.get(i);
  //    rp.drawRipples();
  //  }
  //for (Box b: boxes) {
  if ( multiPoints!=null && multiPoints.size()>0 ) { 
    for (int i=0; i<multiPoints.size (); ++i) {
      PVector m=multiPoints.get(i);
      fill(0, 0, 100);

      ellipse(m.x, m.y, 30, 30);
      //ripples.add(new Ripple(m.x, m.y));
      // b.attract(m.x, m.y);
    }
  } else if (multiPoints.size()==0) {
    println("no touchPoint detected!");
  }
}
//multiPoints=new ArrayList<PVector>();
//}

void mousePressed() {


  addFly();
}
void addFly() {
  if (numFlies < MAX_FLIES) {

    flies[numFlies] = new Fly(mouseX, mouseY);
    numFlies++;
  }
}

void clear_cache(){
   for (int i=0;i<5;i++){
   drops[i]=new PVector(-1,-1); 
  } 
}

