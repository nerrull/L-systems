PVector orientation;
import java.util.*; 

class ParametricRule {
    void rule(Module m, ArrayList<Module> word){};
    
    boolean rule(Module m, ArrayList<Module> word, boolean dirty){
      rule(m,word);
      return false;
    }
    boolean rule(Module m, ArrayList<Module> word, float growth_step){
      rule(m,word, true);
      return false;
    }
}

class Module{
  String letter;
  HashMap<String, Float> parameters;
  
  Module(String l){
    letter = l;
    parameters = new HashMap<String, Float>();
  }
  Module(String l, HashMap<String, Float> p){
    letter = l;
    parameters = p;
  }
  
  void addParam(String name, float value){
      parameters.put(name, value);
  }
  
  void updateParam(String s, float v){
    parameters.replace(s, v);
  }
  
  void drawFunction(){
    return;
  }
  void drawFunction(PShape p){
    drawFunction();
  }
  
  //Return how much the index is incremented by
  int drawFunction(PShape p, int idx){
    drawFunction(p);
    return 0;
  }
  
  float getP(String s){
    return parameters.get(s);
  }
  
  String repr(){
    return this.letter;
  }
  
  Module grow(){
    return this;
  }  
}

class ParametricLSystem{
  int updateNumber =0;
  HashMap<String, ParametricRule> rules;
  Word word;
  WordTree wordTree;

  boolean finished = false;
  ArrayList<ArrayList<Module>> segments;
  ArrayList<Module> newSegment;
  
  float xPos = 0;
  float yPos = 0;
  float zPos = 0;
  float growth_step, size_factor, axial_range, radial_range;

  float plantAge;

  ParametricLSystem(){
    rules = new HashMap<String, ParametricRule>();
    word = new Word();
    wordTree = new WordTree();
    segments = new ArrayList<ArrayList<Module>>(1024);
    newSegment = new ArrayList<Module>(1024);
    plantAge =0;
    defineGeneralRules();
  }
  
    //<>//
  float updateTree(){
    updateNumber ++;
    if (finished){
      plantAge +=1;
      return 0 ;
    }
    
    int ndirty = wordTree.update(this.rules, this.growth_step);
    wordTree.parse();
    return ndirty; 
  }
  
  boolean isFinished(){
    finished = wordTree.isDone();
    return finished;

  }
  
   void drawTree(PGraphics p){
    pushMatrix();
    pushStyle();
    wordTree.draw(p);
    popStyle();
    popMatrix();
  }
  
  void printWord(){
    println();

    wordTree.printWord();

    println();
    println();

  }
  
  void repr(){
    println();
     for(Module m : word.modules){
       print(m.repr());
     }
  }
  
  void defineRules(){
    throw( new  java.lang.UnsupportedOperationException());
  }
  
  void setVariant(int i){
    
  }
  
  void setGrowthRate(float g){
    this.growth_step =g;
  }  
  
  void setSizeFactor(float f){
    this.size_factor= f;
  }
  
  void setStartState(){
    turtle.reset();
    turtle.moveTo(xPos, yPos, zPos);
    this.wordTree.updateRootState(new TurtleState(turtle));
  }
  
  void setPosition(float px,float py, float pz){
    this.xPos = px;
    this.yPos =py;
    this.zPos =pz;

  }
  void setPosition(float px,float py){
    this.xPos = px;
    this.yPos =py;
  }
  
  PVector getPosition(){
    return new PVector(this.xPos, this.yPos, this.zPos);
  }
  
  void defineGeneralRules(){
   rules.put("D", D);
   rules.put("I", I);
   rules.put("IR", IR);
   rules.put("LP", LP);
   rules.put("TR", TR);

  }
}
  

ParametricRule D = new ParametricRule() {
       public boolean rule(Module m, ArrayList<Module> ret, float growthStep) { 
          float age = m.getP("age");
          DelayModule dm = (DelayModule) m; 
          dm.updateParam("age",age-growthStep);
          if (age >0){
            ret.add(dm);
          }
          else {
            ret.add(dm.output);
          }
          return false;
        }
    };

 ParametricRule I = new ParametricRule() {
      public boolean rule(Module m, ArrayList<Module> ret, float growthStep) { 
        float age = m.getP("age");
        float growth_min = 0.1;        
        m.updateParam("age", age - growthStep);
        if (age >0){
           ret.add(m);
           if ( (age <m.getP("start_age"))&& (age/growth_min - floor(age/growth_min)) <growthStep){  
            return true;
          }
        }
        else {
          float l = m.getP("start_age");
          ret.add(new F(l));
          return true;
        }
        return false;
      }
    };
    
    ParametricRule IR=  new ParametricRule() {
       public boolean rule(Module m, ArrayList<Module> ret, float growthStep ) { 
        float age = m.getP("age");
        float axial_range=  m.getP("axial_range");
        float radial_range = m.getP("radial_range");
        if (age >0){
          if (age - floor(age) <growthStep){
            ret.add(new Raxial(random(-axial_range, axial_range)));
            ret.add(new Rradial(random(-radial_range, radial_range)));
            ret.add(new I(1));
            ret.add(new IR(age-growthStep, axial_range, radial_range));
            return true;
          }
          else{
            ret.add(new IR(age-growthStep,  axial_range, radial_range));
          }
        }
        
        else {
            ret.add(new Raxial(random(-axial_range, axial_range)));
            ret.add(new Rradial(random(-radial_range, radial_range)));
            ret.add(new I(1));     
            return true;
       }
       return false;     
      }
    };


ParametricRule LP = new ParametricRule() {
       public boolean rule(Module m, ArrayList<Module> ret, float growthStep) { 
          float age = m.getP("age");
          float maxAge = m.getP("maxAge");

          if (age <maxAge){
            m.updateParam("age", min(maxAge, age + growthStep));
            ret.add(m);
            return true;
          }
          else {
            ret.add(m);
          }
          return false;
        }
    };

ParametricRule TR  = new ParametricRule() {
      public boolean rule(Module m,  ArrayList<Module> ret, float growthStep) { 
        float age = m.getP("age");
        TimedRotation tr = (TimedRotation) m; 
        if (age >0){
          tr.updateParam("age",max(age-growthStep, 0));
          tr.updateAngle();
          ret.add(tr);
        }
        else {
          ret.add(tr.rotationModule);
        }
        return true;
      }
    };
