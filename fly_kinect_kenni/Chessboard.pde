Chessboard chessboard;

class Chessboard
{
  Chessboard()
  {
      
    
  }

  void DrawChessBoard( float cols, float rows)
  {
    if (cols<=0) {
      cols =1;
    }
    if (rows<=0) {
      rows =1;
    }
    float recWidth = width/cols;
    float recHeight = height/rows;

    for (int i =0; i<cols; i++)
    {
      for (int j =0; j< rows; j++)
      {
        float x =i*recWidth;
        float y =j*recHeight;
        if ((i+j)%2==0)
        {
          fill(0);
          rect(x, y, recWidth, recHeight);
          rect(x+recWidth, y+recHeight, recWidth, recHeight);
        }
        else
        {
          fill(255);
          rect(x, y, recWidth, recHeight);
          rect(x+recWidth, y+recHeight, recWidth, recHeight);
        }
      }
    }
    //Draw Outer White Frame Line
    fill(255);
    noStroke();
    rect(0, 0, width, 5);
    rect(0, height-5, width, 5);
    rect(0, 0, 5, height);
    rect(width-5, 0, 5, height);
  }
}

