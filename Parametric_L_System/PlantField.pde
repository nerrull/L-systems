class PlantField{
  ArrayList<ParametricLSystem> plants;
  float xMin, xMax, yOff, zMin, zMax;
  float growthRate;
  boolean LOCK;
  float windStength = 10.;
  
  PriorityQueue<Integer> q;
  Sun2 sun;
  PlantField(){
    q = new PriorityQueue<Integer>();
    plants=  new ArrayList<ParametricLSystem>();
    growthRate = 0.01;
    sun = new Sun2();
  }
  
  void setXRange(float xmin, float xmax){
    xMin = xmin;
    xMax = xmax;
  }
    
  void setZRange(float zmin, float zmax){
    zMin = zmin;
    zMax = zmax;
  }
  void setYOffset(float y){
    yOff = y;
  }
  
  void setGrowthRate(float g){
    growthRate =g;
    for (ParametricLSystem plant:plants){
      plant.setGrowthRate(growthRate);
    }
  }
  

  void addPlant(){
    if (LOCK) return;
    float xpos = random(xMin, xMax);
    float zpos = random(zMin, zMax);

    //ParametricLSystem plant = new  SheperdsPurse();
    
    ParametricLSystem plant = new  Tulip();
    plant.setPosition(xpos, yOff, zpos);
    plant.setGrowthRate(growthRate+random(-0.005, 0.005));
    plant.setSizeFactor(random(0.5, 1));
    plants.add(plant);
  }
  
  void update(){
    sun.update();
    if (q.peek()!=null){
      q.remove();
      addPlant();
    }
      
   float t= 0;
   int dirty = 0;
   for(ParametricLSystem p: plants){
     turtle.reset();
     if (sun.isDay()){
       PVector v = p.getPosition();
       PVector sun_d = sun.getPosition();
       //turtle.setTropism(sun_d.sub(v).normalize(), .2);
     }
     else{
       //turtle.TROPISM =false;
     }
     dirty +=p.updateSegments();
   }
   //println ("Time spent applying rules : "+ t );
   if (dirty >10){
     println ("NDirty: " +dirty );
   }
   //println("time: " + sun.getTime());
  }
  
  void draw(){
    
    for(ParametricLSystem p: plants){
      p.drawSystemSegments();
    }
    sun.draw(turtle.canvas, 20);
  }
  
  void repr(){
    plants.get(0).repr();
  }

}



class Sun {
  float orbit_radius = 1000; 
  float x_position, y_position;
  float time;
  float orbit_speed= 100;
  Sun(){
    time =0;
  }
  void update() {
    time = time +1/orbit_speed;
    if ((1. - time) <1./orbit_speed ) time =0;
    x_position = -orbit_radius*cos(2*PI*time -PI/2);
    y_position = -orbit_radius*(sin(2*PI*time -PI/2));
  }
  
  PVector getPosition(){
    return new PVector(this.x_position, this.y_position, 0);
  }
  
  boolean isDay(){
    return this.y_position <0;
  }
  
  float getTime(){
    return this.time *24;
  }
  void draw(PGraphics canvas, float size){
    canvas.pushMatrix();
    canvas.translate(x_position, y_position);
    canvas.sphere(size); 
    canvas.popMatrix();
  }
}



class Sun2 {
  float orbit_radius = 1000; 
  float x_position, y_position, z_position;
  float time;
  float orbit_speed= 100;
  Sun2(){
    time =0;
    y_position =-400;
  }
  void update() {
    time = time +1/orbit_speed;
    if ((1. - time) <1./orbit_speed ) time =0;
    x_position = -orbit_radius*cos(2*PI*time -PI/2);
    z_position = -orbit_radius*(sin(2*PI*time -PI/2));
  }
  
  PVector getPosition(){
    return new PVector(this.x_position, this.y_position, this.z_position);
  }
  
  boolean isDay(){
    //return this.y_position <0;
    return true;
  }
  
  float getTime(){
    return this.time *24;
  }
  void draw(PGraphics canvas, float size){
    canvas.pushMatrix();
    canvas.translate(x_position, y_position, z_position);
    canvas.sphere(size); 
    canvas.popMatrix();
  }
}
