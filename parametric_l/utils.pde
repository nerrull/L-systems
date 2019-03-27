void drawAxes(){
  pushStyle();
    strokeWeight(3);
  stroke(255,0,0);
  line(0,0,0,100,0,0);
  stroke(0,255,0);
  line(0,0,0,0,100,0);
  stroke(0,0,255);
  line(0,0,0,0,0,100);
  popStyle();
}

void drawDebugLine(PVector v){
  pushStyle();
  stroke(255,0,0);
  strokeWeight(1);
  line(0,0,0,v.x*20,v.y*20,v.z*20);
  popStyle();
}


void drawDebugLine(PVector v, color c){
  pushStyle();
  stroke(c);
  strokeWeight(1);
  line(0,0,0,v.x*20,v.y*20,v.z*20);
  popStyle();
}

float gaussian(float mean, float sigma){
  return  sigma*randomGaussian()+mean;
}
