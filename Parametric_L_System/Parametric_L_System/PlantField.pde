class PlantField{
  ArrayList<ParametricLSystem> plants;
  float xMin, xMax, yOff;
  float growthRate;
  boolean LOCK;
  float windStength = 10.;
  PriorityQueue<Integer> q;
  PlantField(){
    q = new PriorityQueue<Integer>();
    plants=  new ArrayList<ParametricLSystem>();
    growthRate = 0.01;
    
  }
  
  void setXRange(float xmin, float xmax){
    xMin = xmin;
    xMax = xmax;
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
    float pos = random(xMin, xMax);
    ParametricLSystem plant = new  SheperdsPurse();
    plant.setPosition(pos, yOff);
    plant.setGrowthRate(growthRate+random(-0.005, 0.005));
    plant.setSizeFactor(random(0.5, 1));

    plants.add(plant);
  }
  
  void update(){
    if (q.peek()!=null){
      q.remove();
      addPlant();
    }
      
   float t= 0;
   int dirty = 0;

   for(ParametricLSystem p: plants){
     turtle.reset();
     dirty +=p.updateSegments();
   }
   //println ("Time spent applying rules : "+ t );
   println ("NDirty: " +dirty );

  }
  
  void draw(){
     wind.update(windStength);

    for(ParametricLSystem p: plants){
      p.drawSystemSegments();
    }
  }


}
