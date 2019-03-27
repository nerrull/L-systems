class PlantField{
  ArrayList<GrowingPlant> plants;
  float xMin, xMax;
  
  PlantField(){
    plants=  new ArrayList<GrowingPlant>();
  }
  
  void setXRange(float xmin, float xmax){
    xMin = xmin;
    xMax = xmax;
  }
  
  void addPlant(){
    float pos = random(xMin, xMax);
    GrowingPlant plant = new  GrowingPlant();
    plant.setPosition(pos, 0);
    plants.add(plant);
  }
  
  void update(){
   for(GrowingPlant p: plants){
     p.update();
   }
  }
  
  void draw(){
    for(GrowingPlant p: plants){
      turtle.reset();
      p.drawSystem();
    }
  }


}
