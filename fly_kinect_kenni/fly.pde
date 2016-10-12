class Fly {
  // swarm animation
  float homeX, homeY;
  float rangeX, rangeY;
  float angle;
  float step;
  //PShape s;
  //  PImage flyImage;

  int numFrame=236;
  ArrayList<PVector> particles = new ArrayList<PVector>();
  color traceColor;

  float ry;
  // current position
  float currX, currY;

  // move animation
  float targetX, targetY;
  boolean atTarget;

  // paing variables
  int bodySize;
  int wingSpan;
  float flap;
  float flapStep;

  Fly(float x, float y) {
    // init the move variables
    homeX = random(x-SWARM_OFFSET, x+SWARM_OFFSET);
    homeY = random(y-SWARM_OFFSET, y+SWARM_OFFSET);
    newTarget(homeX, homeY);

    // init the swarm variables
    rangeX = random(20, 300);
    rangeY = random(20, 200);
    angle = 0;
    step = random(-0.1, 0.1);

    // init the paint variables
    bodySize = (int)random(5, 10);
    wingSpan = (int)random(5, 10);
    flap = 0;
    flapStep = (bodySize*1.0/wingSpan)/5;
  }

  void paint() {
    //    pushMatrix();
    //    translate(currX, currY);
    //
    //    rotate(ry);
    //    scale(0.13);
    //    image(loopingGif, -75, -75);
    //
    //    ry += 0.02;
    //
    //    popMatrix();
    for (int i=0; i<particles.size ()-1; i++) {
      PVector tempVector=particles.get(i);
      PVector tempVector2=particles.get(i+1);

      stroke(traceColor, map(i, 0, 300, 0, 125));
      strokeWeight(map(i, 0, 300, 0, 15));
      line(tempVector.x, tempVector.y, tempVector2.x, tempVector2.y);
    }
    //    if (particles.size()<numFrame) {
    //      particles.add(new PVector(currX, currY));
    //    } else {
    //      particles.remove(0);
    //      particles.add(new PVector(currX, currY));
    //    }
    if (particles.size()==0) {
      particles.add(new PVector(currX, currY));
    }
    if (particles.size()<numFrame) {
      particles.add(new PVector(currX, currY));
    } else {
      particles.remove(0);
      particles.add(new PVector(currX, currY));
    }
    PVector tempDirection=new PVector((currX-particles.get(particles.size()-2).x), (currY-particles.get(particles.size()-2).y));
    float a=tempDirection.heading();
    pushMatrix();
    //rotate(a);
    translate(currX, currY);
    rotate(a+HALF_PI);
    image(loopingGif, -15, -15, 15, 15);
    popMatrix();
  } 

  void move() {
    float noiseVal = noise(random(0, 5));
    noiseVal = noiseVal*10;
    // calculate the distance to the target
    float dX = targetX-homeX;
    float dY = targetY-homeY;

    // calculate the current step towards the target
    float stepX = dX/10;
    float stepY = dY/10;

    homeX += stepX;
    homeY += stepY;

    // if we're close enough to the target...
    if (abs(dX) < 1 && abs(dY) < 1) {
      // ...assume we've reached it
      atTarget = true;
    }
  }

  void swarm() {
    // hover around the home position

    currX = int(rangeX*sin(angle)+homeX);
    currY = int(rangeY*cos(angle)+homeY);
    angle += step;
  }

  void newTarget(float newX, float newY) {
    // set a new target position for the home



    targetX = random(newX-50, newX+50);
    targetY = random(newY-50, newY+50);


    atTarget = false;
  }

  boolean isAtTarget() {
    return atTarget;
  }

  void catch_near() {
    float tempDistance=999;
    int tempIndex=0;
    for (int i=0; i<5; i++) {
      if (i==0) {
        tempDistance=dist(currX, currY, drops[0].x, drops[0].y);
        tempIndex=0;
      } else {
        float ttDistance=dist(currX, currY, drops[i].x, drops[i].y);    
        if (ttDistance<tempDistance) {
          tempDistance=ttDistance;
          tempIndex=i;
        }
      }
    }
    newTarget(drops[tempIndex].x, drops[tempIndex].y);
  }
}

