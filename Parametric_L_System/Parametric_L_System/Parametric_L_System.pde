import peasy.*;

ParametricLSystem plant;
PlantField field;
ShapeTurtle turtle;

ShapeTurtle getTurtle(){
  return turtle;
}

String system;
float globalAngle;
PeasyCam cam;

boolean DRAW_AXES;
void settings() {
  size(1000, 800,P3D);
    smooth(4);

}
void setup(){
    controlFrame = new ControlFrame(this, 300,100, "Controls");

  frameRate(30);
  turtle=  new ShapeTurtle();
  plant = new SheperdsPurse();
  field = new PlantField();
  field.setXRange(-200, 200);
  field.setYOffset(100 );

  int nPlants =1;
  for (int i=0; i<nPlants; i++){
    field.addPlant();
  }

  stroke(0,0,0, 255);
  globalAngle = 1/180.*PI;
  cam = new PeasyCam(this, 300);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(2000);
  cam.lookAt(0,0,0);
  DRAW_AXES = false;
}

void draw(){
  float t0= millis();
  surface.setTitle("FPS: "+frameRate);
  turtle.reset();
  background(255);
  translate(0,0, 0);
  float t= millis();
  //plant.grow();
  //plant.drawSystemSegments();
  field.draw();
  println("Time spent drawing: "+ (millis() -t) );

  t= millis();
  field.update();
  //plant.updateSegments();
  println("Time spent updating: "+ (millis() -t) );
  //println("Time spent in draw: "+ (millis() -t0) );

}

void setGrowthRate(float g){
}

void keyPressed(){
    //plant.update();

  plant.printWord();
  
}
  
