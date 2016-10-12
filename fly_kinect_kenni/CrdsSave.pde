
float[] x = new float[4];
float[] y = new float[4];
String[] lines;

void loadCoords() {
  lines = loadStrings("lines.txt");
  println("lines.length="+lines.length);
  for (int i=0;i<lines.length;++i) {
    String[] pieces = split(lines[i], '\t');
    if (pieces.length == 2) {
      float x = int(pieces[0]);
      float y = int(pieces[1]);
      IRPoints[i]=new PVector(x, y);
      println("x["+i+"]="+pieces[0]+","+"y["+i+"]="+pieces[1]);
    }
  }
}

void IRPointsSet() {
  if (keyPressed) {

    if (key=='0') {
      IRPoints[0]=TPoint;
      x[0]=TPoint.x;
      y[0]=TPoint.y;
      println("IRPoints[0] have been set at("+TPoint.x+","+TPoint.y+")");
    }
    else if (key=='1') {
      IRPoints[1]=TPoint;
      x[1]=TPoint.x;
      y[1]=TPoint.y;
      println("IRPoints[1] have been set at("+TPoint.x+","+TPoint.y+")");
    }
    else if (key=='2') {
      IRPoints[2]=TPoint;
      x[2]=TPoint.x;
      y[2]=TPoint.y;
      println("IRPoints[2] have been set at("+TPoint.x+","+TPoint.y+")");
    }
    else if (key=='3') {
      IRPoints[3]=TPoint;
      x[3]=TPoint.x;
      y[3]=TPoint.y;
      println("IRPoints[3] have been set at("+TPoint.x+","+TPoint.y+")");
    }
    else if (key==' ') {
      aftIR=new AFT(IRPoints, windowPoints);
      IR=true;
      begin=false;
      println("IRPoints have been set");
    }
    else if (key=='s') {
      String[] line = new String[4];
      for (int i = 0; i < 4; i++) {
        line[i] = x[i] + "\t" + y[i];
      }
      saveStrings("lines.txt", line);
      println("Data saved");
    }
    else if (key=='l') {
      loadCoords();
      println("Data loaded");
    }
    else if (key=='k') {
      IR=false;
    }
    else if (key=='b') {
      begin=true;
    }
    else if (key=='=') {
      IRdepth+=20;
      println(IRdepth);
    }
    else if (key=='-') {
      IRdepth-=20;
      println(IRdepth);
    }
  }
}

