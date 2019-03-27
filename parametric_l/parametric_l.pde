import peasy.*;

ParametricLSystem plant;
PlantField field;
Turtle turtle;

Turtle getTurtle(){
  return turtle;
}

String system;
float globalAngle;
PeasyCam cam;
Root r;
boolean DRAW_AXES;

void setup(){
  size(1000,800, P3D);
  smooth(4);
  turtle=  new Turtle();

  //plant = new Tree();
  plant = new Ternary();
  plant.setVariant(0);
  ////plant.setVariant(2);
  //plant = new CircularTernary();
  //plant = new Spiral();
  r = new Root();
  
  //field = new PlantField();
  //field.setXRange(-100, 100);
  //int nPlants = 1;
  //for (int i =0; i<nPlants;i ++){
  //  field.addPlant();
  //}



  stroke(255,255,255, 255);
  globalAngle = 1/180.*PI;
  cam = new PeasyCam(this, 300);
  cam.setMinimumDistance(-3000);
  cam.setMaximumDistance(3000);
  cam.lookAt(0,0,0);
  DRAW_AXES = false;
}

void draw(){
  surface.setTitle("FPS: "+frameRate);
  turtle.reset();
  pushMatrix();
  background(0);
  translate(0,0, 0);
  //rotate(PI/2);
  field.draw();
  plant.drawSystem();
  r.drawSystem();
  field.update();
  popMatrix();
  if (DRAW_AXES){
    drawAxes();
  }
}

void keyPressed(){
  if (key == ' '){
    field.update();
    //r.update();
    plant.update();
    //r.repr();
  }
  
  if (key == 'a'){
    turtle.e -=0.1;
    println("Elasticity " + turtle.e);
  }
  if (key == 'd'){
    turtle.e +=0.1;
     println("Elasticity " + turtle.e);
  }
  //if (key == 'A'){
  //  plant.angle -=.1/180.*PI;
  //}
  //if (key == 'D'){
  //  plant.angle +=.1/180.*PI;
  //}
  // if (key == 'w'){
  //  plant.forward_length -=1.;
  //}
  //if (key == 's'){
  //  plant.forward_length +=1.;
  //}
  //if (key == 'r'){
  //  plant.angle +=  random(-1,1)*1/180.*PI;
  //}
  if (key == 'x'){
    DRAW_AXES = !DRAW_AXES;
  }
}
