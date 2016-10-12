import SimpleOpenNI.*;
import blobDetection.*;
SimpleOpenNI  context;
BlobDetection theBlobDetection;
Kinect kinect;

PImage BlobMap;
PImage img;
PImage Stage;
int imgW, imgH;


class Kinect
{
  Kinect(PApplet setups_this)
  {

    imgW=80;
    imgH=60;
    context = new SimpleOpenNI(setups_this);
    if (context.isInit() == false)
    {
      println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
      exit();
      return;
    }
    context.setMirror(true);
    context.enableDepth();
    context.enableRGB();

    BlobMap=new PImage(640, 480);
    Stage=new PImage(640, 480);
    img = new PImage(imgW, imgH); 
    theBlobDetection = new BlobDetection(img.width, img.height);
    theBlobDetection.setPosDiscrimination(true);
  }

  PImage DepthImg()
  { 
    return context.depthImage();
  }

  PImage RGBImg()
  { 
    return context.rgbImage();
  }

  void update() {
    context.update();
  }

  void drawBlob(PVector[] points) {
//    PVector[] pv;
//    pv=points;

    int index;
    //context.update();
    int[]   depthMap = context.depthMap();

    loadPixels();
    
    for (int y=0;y< context.depthHeight();y++) {
      for (int x=0;x< context.depthWidth();x++) {
        //if (x>minX && x<maxX && y>minY && y<maxY) {
        index = x + y *context.depthWidth();
        if (depthMap[index] >IRdepth && depthMap[index] <IRdepth+20) {

          pixels[index]=color(255, 255, 255, 50);
        }
        else { 
          pixels[index]=color(0, 0, 0, 50);
        }
        BlobMap.pixels[index]=pixels[index];
        BlobMap.updatePixels();
      }
    }



    img.copy(BlobMap, 0, 0, 640, 480, 0, 0, imgW, imgH);
    //fastblur(img, 1);
    //background(0);
    if (IR==false) {
      //image(img, 0, 0, 1024, 768);
    }
    theBlobDetection.computeBlobs(img.pixels);
    drawBlobsAndEdges(true, true);
  }


  void drawBlobsAndEdges(boolean drawBlobs, boolean drawEdges)
  {
    //multiPoints=new ArrayList<PVector>();
    noFill();
    Blob b;
    EdgeVertex eA, eB;
    println(theBlobDetection.getBlobNb());
    for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
    {
      b=theBlobDetection.getBlob(n);

      if (b!=null)
      {
        // Edges
        if (drawEdges)
        {
          strokeWeight(3);
          stroke(0, 0, 0);
          for (int m=0;m<b.getEdgeNb();m++)
          {
            eA = b.getEdgeVertexA(m);
            eB = b.getEdgeVertexB(m);
            if (eA !=null && eB !=null)
              line(
              eA.x*width, eA.y*height, 
              eB.x*width, eB.y*height
                );
          }
        }

        // Blobs
        if (drawBlobs)
        {
          strokeWeight(1);
          stroke(0, 0, 0);
          rect(
          b.xMin*width, b.yMin*height, 
          b.w*width, b.h*height
            );
          ellipse(b.xMin*width+b.w*width/2, b.yMin*height+b.h*height/2, 5, 5);
         
         if (n<5){
          drops[n].x=screenX(b.xMin*width+b.w*width/2, b.yMin*height+b.h*height/2);
          drops[n].y=screenY(b.xMin*width+b.w*width/2, b.yMin*height+b.h*height/2);
         }
         // multiPoints.add(drops[0]);
          //println(mx+" "+my);
        }
        
        if (IR==false) {
          TPoint=new PVector(b.xMin*width+b.w*width/2, b.yMin*height+b.h*height/2);
        }
      }
    }
  }


  // ==================================================
  // Super Fast Blur v1.1
  // by Mario Klingemann 
  // <http://incubator.quasimondo.com>
  // ==================================================
  void fastblur(PImage img, int radius)
  {
    if (radius<1) {
      return;
    }
    int w=img.width;
    int h=img.height;
    int wm=w-1;
    int hm=h-1;
    int wh=w*h;
    int div=radius+radius+1;
    int r[]=new int[wh];
    int g[]=new int[wh];
    int b[]=new int[wh];
    int rsum, gsum, bsum, x, y, i, p, p1, p2, yp, yi, yw;
    int vmin[] = new int[max(w, h)];
    int vmax[] = new int[max(w, h)];
    int[] pix=img.pixels;
    int dv[]=new int[256*div];
    for (i=0;i<256*div;++i) {
      dv[i]=(i/div);
    }

    yw=yi=0;

    for (y=0;y<h;y++) {
      rsum=gsum=bsum=0;
      for (i=-radius;i<=radius;++i) {
        p=pix[yi+min(wm, max(i, 0))];
        rsum+=(p & 0xff0000)>>16;
        gsum+=(p & 0x00ff00)>>8;
        bsum+= p & 0x0000ff;
      }
      for (x=0;x<w;x++) {

        r[yi]=dv[rsum];
        g[yi]=dv[gsum];
        b[yi]=dv[bsum];

        if (y==0) {
          vmin[x]=min(x+radius+1, wm);
          vmax[x]=max(x-radius, 0);
        }
        p1=pix[yw+vmin[x]];
        p2=pix[yw+vmax[x]];

        rsum+=((p1 & 0xff0000)-(p2 & 0xff0000))>>16;
        gsum+=((p1 & 0x00ff00)-(p2 & 0x00ff00))>>8;
        bsum+= (p1 & 0x0000ff)-(p2 & 0x0000ff);
        ++yi;
      }
      yw+=w;
    }

    for (x=0;x<w;x++) {
      rsum=gsum=bsum=0;
      yp=-radius*w;
      for (i=-radius;i<=radius;++i) {
        yi=max(0, yp)+x;
        rsum+=r[yi];
        gsum+=g[yi];
        bsum+=b[yi];
        yp+=w;
      }
      yi=x;
      for (y=0;y<h;y++) {
        pix[yi]=0xff000000 | (dv[rsum]<<16) | (dv[gsum]<<8) | dv[bsum];
        if (x==0) {
          vmin[y]=min(y+radius+1, hm)*w;
          vmax[y]=max(y-radius, 0)*w;
        }
        p1=x+vmin[y];
        p2=x+vmax[y];

        rsum+=r[p1]-r[p2];
        gsum+=g[p1]-g[p2];
        bsum+=b[p1]-b[p2];

        yi+=w;
      }
    }
  }
}

