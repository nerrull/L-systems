 import peasy.*;

ParametricLSystem plant;
PlantField field;
ShapeTurtle turtle;
Renderer render;

ShapeTurtle getTurtle(){
  return turtle;
}

PeasyCam cam;
boolean DEBUG = true;
boolean DRAW_AXES;

void settings(){
  size(1000, 800,P3D);
}

void setup(){

  controlFrame = new ControlFrame(this, 300,100, "Controls");
  render=  new Renderer(this);
  frameRate(60);
  
  turtle=  new ShapeTurtle();
  turtle.setCanvas(render.getCanvas());
  
  field = new PlantField();
  field.setXRange(-100, 100);
  field.setZRange(-100, 100);
  field.setYOffset(0 );

  int nPlants =1;
  for (int i=0; i<nPlants; i++){
    field.addPlant();
  }
  
  stroke(0,0,0, 255);
  
  cam = new PeasyCam(this, 300);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(2000);
  cam.lookAt(0,0,0);
 
  DRAW_AXES = false;
  background(255);
}
void drawAxes(){
  render.canvas.strokeWeight(2);
  render.canvas.stroke(255,0,0);
  render.canvas.line(0,0, 0, 100,0,0);
  render.canvas.stroke(0,255,0);
  render.canvas.line(0,0, 0, 0,100,0);
  render.canvas.stroke(0,0,255);
  render.canvas.line(0,0, 0, 0,0,100);

}
void draw(){
  background(0);
  float t= millis();

  field.update();
  float t2 = millis() -t;
  if (DEBUG && t2 >10){
    println("Time spent updating: "+t2 );
  }
  //Draw
  render.beginDraw(this);
  //Motion blur effect here
  float t0= millis();
  turtle.reset();
  t= millis();
  field.draw();
  
  if (DRAW_AXES){
    drawAxes();
  }
  render.endDraw();  
  render.draw(0,0,width,height);
  t2 = millis() -t;
  if (DEBUG && t2 >10){
    println("Time spent drawing: "+ t2 );
  }
  //println("Time spent in draw: "+ (millis() -t0) );

}


void mouseMoved(){

}
void setGrowthRate(float g){
}

void keyPressed(){
  if (key ==' '){
    field.repr();

  }
    if (key =='d'){
    DRAW_AXES = !DRAW_AXES;

  }
  //plant.printWord();
  
}
