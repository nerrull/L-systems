import peasy.*;
import javafx.util.Pair;

ControlFrame controlFrame;

ParametricLSystem plant;
PlantField field;
ShapeTurtle turtle;
Renderer render;
LeafManager leafManager;
ColorPicker colorPicker;

ShapeTurtle getTurtle(){
  return turtle;
}

PeasyCam cam;
boolean DEBUG = true;
boolean DRAW_AXES;
boolean SWAY =false;

void settings(){
  //size(1920, 950,P3D);
  fullScreen(P3D);
}

void setup(){
  SWAY = false;
  initMidi();

  render=  new Renderer(this);
  frameRate(30);
  
  turtle=  new ShapeTurtle();
  turtle.setCanvas(render.getCanvas());
  colorPicker = new ColorPicker();

  field = new PlantField();
  field.setXRange(-135, 135);
  field.setZRange(-250, 0);
  field.setYOffset(0 );

//  int nPlants =1;
//  for (int i=0; i<nPlants; i++){
//    field.addPlant();
//  }
  
  stroke(0,0,0, 255);
  
  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(0);
  cam.setMaximumDistance(2000);
  cam.lookAt(0,0,0);
  saveCamPosition();
 
  DRAW_AXES = false;
  background(255);
  
  
  //Create control frame 
  controlFrame = new ControlFrame(this, 400,400, "Controls");
  current_angle = 0;
  angle_increment = -0.01;
  max_rotation_angle = 15;

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
  if(SWAY){
    updateCamPosition();
  }
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
  field.draw(render.getCanvas());
  
  if (DRAW_AXES){
    drawAxes();
  }
  render.endDraw();  
  render.draw(0,0,width,height);
  t2 = millis() -t;
  if (DEBUG && t2 >10){
    //println("Time spent drawing: "+ t2 );
  }
  //println("Time spent in draw: "+ (millis() -t0) );
}


void mouseMoved(){

}


void keyPressed(){
  if (key ==' '){
    field.repr();

  }
  if (key =='d'){
    DRAW_AXES = !DRAW_AXES;

  }
  if (key =='c'){
    SWAY = !SWAY;
    println("SWAY " + SWAY);

  }
  
  if (key =='a'){
      Note note = new Note(15,64, 75);
      println();
      println("Percussive Note On:");
      println("--------");
      println("Channel:"+note.channel());
      println("Pitch:"+note.pitch());
      println("Velocity:"+note.velocity());
      myBus.sendNoteOn(note);

  }
  if (key =='s'){
    saveCamPosition();
  }
  
  if (key =='l'){
    loadCamPosition();  

  }
  //plant.printWord();
  
}
