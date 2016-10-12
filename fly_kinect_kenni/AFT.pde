import papaya.*;

AFT aftIR;

class AFT {

  float  [] T;//特征向量
  PVector [] pts, npts;//定义：pts 原校对指针  npts新校对指针

  //========================================================================================

  AFT(PVector[] p, PVector[] np) {

    pts= new PVector[4];
    for (int i=0;i<4;++i)pts[i]=p[i];

    npts=new PVector[4];
    for (int i=0;i<4;++i)npts[i]=np[i];

    T=new float[9];
    for (int i=0;i<9;++i)T[i]=0;
    for (int i=0;i<3;++i)T[4*i]=1;
  }

  void ProjectiveTransform() {
    calAffineTransform();
    applyPM();
  }

  void calAffineTransform() {
    float[][] A= new float[8][9];
    float[][] At, AtA;
    //int numDecimals=3;

    for (int i=0;i<4;++i) {//2*9的矩阵框架
      A[2*i][0]=pts[i].x;// 第n行矩阵
      A[2*i][1]=pts[i].y;
      A[2*i][2]=1;
      A[2*i][3]=0;
      A[2*i][4]=0;
      A[2*i][5]=0;
      A[2*i][6]=-pts[i].x*npts[i].x;
      A[2*i][7]=-pts[i].y*npts[i].x;
      A[2*i][8]=-npts[i].x;

      A[2*i+1][0]=0;//第n+1行矩阵
      A[2*i+1][1]=0;
      A[2*i+1][2]=0;
      A[2*i+1][3]=pts[i].x;
      A[2*i+1][4]=pts[i].y;
      A[2*i+1][5]=1;
      A[2*i+1][6]=-pts[i].x*npts[i].y;
      A[2*i+1][7]=-pts[i].y*npts[i].y;
      A[2*i+1][8]=-npts[i].y;

    }

    At=Mat.transpose(A);
    AtA=Mat.multiply(At, A);

    Eigenvalue eigen=new Eigenvalue(AtA);
    float[][]V=Cast.doubleToFloat(eigen.getV());
    // float[][]D=Cast.doubleToFloat(eigen.getD());
    for (int i=0;i<9;++i) {
      T[i]=V[i][0]/V[8][0];
    }
  }

  //applyPerspectiveMatrix
  void applyPM() {//applyPM() have to be 4*4 Matrix,but homography only need 3*3
    applyMatrix(
    T[0], T[1], 0.0, T[2], 
    T[3], T[4], 0.0, T[5], 
    0.0, 0.0, 1.0, 0.0, 
    T[6], T[7], 0.0, T[8]);
  }
}

