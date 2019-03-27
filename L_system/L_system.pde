
Edge1 plant;

String system;
float globalAngle;


void setup(){
  controlFrame = new ControlFrame(this, 500,600, "Controls");

  smooth();
  plant = new Edge1(); 
  plant.forward_length = -10;
  system = plant.getInitialString();
  stroke(255,255,255, 100);
  globalAngle = 1/180.*PI;
}

void draw(){
  background(0);
  translate(width/2, height);
  rotate(globalAngle);
  //println();
  plant.drawSystem(system);
}

void keyPressed(){
  if (key == ' '){
    system = plant.updateSystem(system);
  }
  
  if (key == 'a'){
    globalAngle -=1/180.*PI;
  }
  if (key == 'd'){
    globalAngle +=1/180.*PI;
  }
  if (key == 'A'){
    plant.angle -=.1/180.*PI;
  }
  if (key == 'D'){
    plant.angle +=.1/180.*PI;
  }
   if (key == 'w'){
    plant.forward_length -=1.;
  }
  if (key == 's'){
    plant.forward_length +=1.;
  }
  if (key == 'r'){
    plant.angle +=  random(-1,1)*1/180.*PI;
  }
  if (key == 'p'){
    println(system);
  }
}
