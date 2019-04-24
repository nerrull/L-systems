class PlantField{
  float xMin, xMax, yOff, zMin, zMax;
  float growthRate;
  boolean LOCK;
  boolean REMOVE = true;
  float windStength = 10.;
  float deathAge;
  int maxPlants = 48;
  //Controls
  PriorityQueue<Integer> q;
  PriorityQueue<Integer> slot_q;
  PriorityQueue<Integer> off_q;
  
  HashMap<UUID,ParametricLSystem> plants;
  UUID[] plantSlots;
  boolean[] slotActive;
  Integer[] slotCount;
  int n_slots;
  
  String [] possiblePlantNames; 
  Class[] possiblePlants;
  ArrayList<Float> plant_odds;
  int selected_index=  0;
  float total_odds = 0;

  Sun2 sun;
  //Wind wind;
  
  PlantField(){
    n_slots =24;
    reset();
    sun = new Sun2();
    possiblePlantNames = new String[] {"plant_2D", "tulip", "spiral", "grass", "sheperds"};
    possiblePlants =  new Class[] {Plant2D.class, Tulip.class, SpiralPlant.class, GrassPlant.class, SheperdsPurse.class};
    plant_odds = new ArrayList<Float>(5);
    for(int i =0; i<5; i++){
      plant_odds.add(1.);
    }
    total_odds =5;
    growthRate = 0.1;
    deathAge = 100.;
  }
  
  void reset(){
    q = new PriorityQueue<Integer>();
    slot_q = new PriorityQueue<Integer>();
    off_q = new PriorityQueue<Integer>();
    
    plantSlots = new UUID[n_slots];
    slotActive = new boolean[n_slots];
    slotCount = new Integer[n_slots];
    
    for(int i  = 0; i<n_slots; i++){
      slotCount[i]=0;
    }
    
    plants=  new HashMap<UUID,ParametricLSystem>(128);
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
  
  void setGrowthRate(float g, boolean updateGui){
    growthRate =g;
    for (ParametricLSystem plant:plants.values()){
      plant.setGrowthRate(growthRate);
    }
    if (updateGui){
      controlFrame.updateGrowthValue(g);
    }
  }
    
  void addPlant(int slot){
    if (LOCK) return;
    float zpos = random(zMin, zMax);

    ParametricLSystem plant = getRandomPlant();
    float slot_width = (xMax -xMin)/n_slots/2;
    float slot_p = map(slot, 0, n_slots, xMin, xMax);
    float xpos = slot_p +random(-slot_width, slot_width);

    plant.setPosition(xpos, yOff, zpos);
    plant.setStartState();
    plant.setGrowthRate(growthRate);
    //plant.setSizeFactor(random(0.5, 1));
    plant.setSizeFactor(1);
    UUID  id = UUID.randomUUID();
    plants.put(id,plant);

    plantSlots[slot] = id;
    slotActive[slot] = true;
          sendPercussiveNote(slot);

  }
  
  void update(){
    sun.update();
    if (q.peek()!=null){
      q.remove();
      addPlant((int)random(0, n_slots));
    }
    int slot;
    if (slot_q.peek()!=null){ 
      slot =(int) (slot_q.poll()*n_slots/24.) ;
      updatePlantSlot(slot);
    }
    
    if (off_q.peek()!=null){ 
      slot = (int) (off_q.poll()*n_slots/24.);
      //slotActive[slot] =false;
    }
      
   float t= 0;
   int dirty = 0;
      for(int i  = 0; i<n_slots; i++){
      if (slotActive[i]){
        //if (sun.isDay()){
        //  PVector v = plants.get(plantSlots[i]).getPosition();
        //  PVector sun_d = sun.getPosition();
        //  turtle.setTropism(sun_d.sub(v).normalize(), .2);
        //}
        updatePlant(i);
        //plants.get(plantSlots[i]).setGrowthRate(growthRate);
      }
   }
    
   ArrayList<UUID> toRemove = new ArrayList<UUID>(4);
   int n_plants = plants.keySet().size();
   for(UUID k: plants.keySet()){
      ParametricLSystem p = plants.get(k);
      p.updateTree();
      //p.printWord();
      if (n_plants >maxPlants){ 
        if (p.plantAge > deathAge){
          toRemove.add(k);
          n_plants--;
        }
      }
    }
   for (UUID k : toRemove){
     removePlant(k);
   }
  }
      
  void draw(PGraphics canvas){
    
    for(ParametricLSystem p: plants.values()){
      p.drawTree(canvas);
    }
    
    //sun.draw(canvas, 20);
    updateCamPosition();
} 
  
  void repr(){
    plants.get(0).repr();
  }
  
  void removePlant(UUID id){
    plants.remove(id);
  }
  
  void incrementSelected(){
    selected_index = (selected_index+1) %plant_odds.size();
    controlFrame.updateSelected(selected_index);
  }
  
   void setSelectedIndex(int idx){
    selected_index = idx;
    controlFrame.updateSelected(selected_index);
  } 
  
  String getSelectedName(){
    return possiblePlantNames[selected_index];
  }
  
  void setOdds(String name , float value){
    int idx;
    for(idx =0; idx< plant_odds.size(); idx++){
      if (possiblePlantNames[idx].equals(name)){
        break;
      }
    }
    setOdds(idx, value, false);
  }
  
  void setOdds(int idx , float value, boolean updateGUI){
    plant_odds.set(idx, value);
    total_odds =0;
    for (float o: plant_odds){
      total_odds+=o;
    }
    if (updateGUI){
      controlFrame.updateOdds(idx,value);
    }
  }
  
  ParametricLSystem getRandomPlant(){
    float r =  random(0,total_odds);
    float tot =0;
    int idx =0;
    for (float o: plant_odds){
      tot= tot+o;
      if (r < tot){
        try{
          println("Generating plant : " + possiblePlantNames[idx]);
          return getPlant(idx);
          //return (ParametricLSystem) possiblePlants[idx].newInstance();
        }
        catch(Exception e){
          println(e);
          println("Failed to instantiate object?");
        }
        
      }
      idx++;
    }
    return new GrassPlant();
  }
  
  
  ParametricLSystem getPlant(int idx){

    switch(idx){
    case 0:
      return new Plant2D();
    case 1:
      return new Tulip();
    case 2:
      return new SpiralPlant();
    case 3:
      return new GrassPlant();
    case 4:
      return new SheperdsPurse();  
    default:
      return new Tulip();
    }
  }
  
  void updatePlantSlot(int slot){
    if(plantSlots[slot] ==null){
      addPlant(slot);
      slotCount[slot] +=1;
      println ("Slotcount " + slot + " is " + slotCount[slot] );

    }
    
    else if (slotActive[slot] && !plants.get(plantSlots[slot]).isFinished()){
      plants.get(plantSlots[slot]).growth_step +=0.1;
    }
    
    else{
        addPlant(slot);
        slotCount[slot] +=1;
        sendPercussiveNote(slot);
    }
    
    
  }
    
  void updatePlant(int slot){
    plants.get(plantSlots[slot]).plantAge =0;
  }
}


class Sun2 {
  float orbit_radius = 300; 
  float x_position, y_position, z_position;
  float time;
  float orbit_speed= 10;
  
  Sun2(){
    time =0;
    y_position =-200;
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
  
  PVector getPos(){
    return new PVector(this.x_position, this.y_position, this.z_position);
  }
  void draw(PGraphics canvas, float size){
    canvas.pushMatrix();
    canvas.translate(x_position, y_position, z_position);
    canvas.sphere(size); 
    canvas.popMatrix();
  }
}


class Wind {
  float amount = 0; 
  float fluctuation = 1000; 

  void update(float strength) {
    amount = (noise(frameCount/1000.) -0.5)*strength;
    //println("Wind amoun"+ amount);
  }
}

Wind wind= new Wind();
int sign(float v){
  if (v>=0) return 1;
  else return -1;
}
