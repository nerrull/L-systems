
class Tulip extends ParametricLSystem{

  float angle,angle2, forward_length, time, timeStep;
  float growth_step, axial_range, radial_range;
  int n_leaves;
  int leaf_size;
  int leaf_interval_mean;
  float leaf_interval;
  float size_factor;
  float leaf_angle, angle_variance;
  
  Tulip(){

    angle = radians(30);
    angle2 = radians(137.5);
    growth_step = 0.1;
    size_factor =1.;
    int num_leaves  = 3 ;
    leaf_size = 12;
    leaf_interval_mean = 9;
    leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2);
    axial_range = radians(2);
    radial_range = radians(10);
    
    leaf_angle= 25;
    angle_variance = 3;
    
    defineRules();
    word = new Word();
    word.add(new Segment());
    word.add(new Green());
    word.add(new Rradial(random(0,radians(360))));
    word.add(new I(leaf_interval));
    word.add(new A(num_leaves));

  }
  
  
  void setGrowthRate(float g){
    this.growth_step= g;
     axial_range = radians(10)*growth_step;
    radial_range = radians(10)*growth_step;
  }
  
  
  void setSizeFactor(float f){
    this.size_factor= f;
  }
  
  void update(){
    super.update();
    time +=timeStep;
  }  
  
  class A extends Module{
    A( float age){
      super("a");
      addParam("age", age);
    }
  
    void drawFunction(){
    }
    
    String repr(){
      return "a" +"("+getP("age")+")";
    }
  }
  
  class BigA extends Module{
    BigA( ){
      super("A");
    }
  
    void drawFunction(){
    }
    
    String repr(){
      return "A" ;
    }
  }
  
  class Leaf extends Module{
    Leaf( float age, float size){
      super("L");
      addParam("age", age);
      addParam("size", size);

    }
  
    void drawFunction(){

    }
    
    String repr(){
      return "L" +"("+getP("age")+ "," +getP("size")+")";
    }
  }
  
 class K extends Module{
    K(float age){
      super("K");
      this.addParam("age", age);

    }
    
    void drawFunction(){
    }
    
    String repr(){
      return "K";
    }
  }
  
  
  class IR extends Module{
    IR(float age){
      super("IR");
      addParam("age", age);

    }
   
    String repr(){
      return "IR" +"("+getP("age")+")";
    }
    
  }
  class X extends Module{
    X(float age){
      super("X");
      addParam("age", age);

    }
  
    void drawFunction(){
    }
    
    String repr(){
      return "X" +"("+getP("age")+")";
    }
  }
  
  class Fruit extends Module{
    Fruit(){
      super("Fruit");
    }
  
    void drawFunction(){
      //stroke(155,0,0);
      //sphere(4);
    }
    
    String repr(){
      return "Fruit";
    }
  }
  class Move extends Module{
    Move(){
      super("MOVE");
    }
  
    void drawFunction(){

    }
  }
  
  float  getLeafSize(){
    float v = random(leaf_size -1,leaf_size +1)*pow(2./3, n_leaves-1);
    return v;
  }
  
  void defineRules(){   
    // a(t) : t>0 → [&(70)L]/(137.5)I(10)a(t-1)
    // a(t) : t=0 → [&(70)L]/(137.5)I(10)A

    rules.put("a", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2)*size_factor;
        float la=  leaf_angle + random(- angle_variance, angle_variance);
        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age <=0){
          ret.add(new Slash(radians(137.5)));         
          ret.add(new DelayModule(10, new BigA()));
        }
        else if (age >0){
          if (age - floor(age) < growth_step){
            n_leaves +=1;
            ret.add(new Segment());
            ret.add(new Green());
            ret.add(new LBrack());
            ret.add(new And(radians(3)));
            
            ret.add(new TimedRotation(10.,radians(la), new And(0)));
            ret.add(new Leaf(0, getLeafSize()));
            ret.add(new RBrack());
            
            ret.add(new Segment());
            ret.add(new Green());
            ret.add(new Slash(radians(180)));
            ret.add(new IR(leaf_interval));
          }
          ret.add(new A(age -growth_step));
        }
        return ret;
      }
    });


    //[&(18)u(4)FFI(10)I(5)X(5)KKKK]/(137.5)I(8)A
    rules.put("A", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2);
        float flower_interval = random(30, 50)*size_factor;

        ArrayList<Module> ret = new  ArrayList<Module>();
        
        ret.add(new LBrack());
        ret.add(new Move());
        ret.add(new IR(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));

        ret.add(new EndCut());
        ret.add(new RBrack());
        return ret;
      }
    });
    
    rules.put("I", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        m.updateParam("age", age - growth_step);
        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age >0){
           ret.add(m);
        }
        else {
          float l = m.getP("start_age");
          ret.add(new F(l));
        }
        return ret;
      }
    });
    
    rules.put("IR", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age >0){
          if (age - floor(age) <growth_step){
            ret.add(new Raxial(random(-axial_range, axial_range)));
            ret.add(new Rradial(random(-radial_range, radial_range)));
            ret.add(new I(1));
            ret.add(new IR(age-growth_step));
          }
          else{
            ret.add(new IR(age-growth_step));
          }
        }
        
        else {
            ret.add(new Raxial(random(-axial_range, axial_range)));
            ret.add(new Rradial(random(-radial_range, radial_range)));
            ret.add(new I(1));        
       }
        return ret;
      }
    });
    
    rules.put("D", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        DelayModule dm = (DelayModule) m; 
        dm.updateParam("age",age-growth_step);
        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age >0){
          ret.add(dm);
        }
        else {
          ret.add(dm.output);
        }
        return ret;
      }
    });
    
   rules.put("TR", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        TimedRotation tr = (TimedRotation) m; 
        tr.updateParam("age",age-growth_step);
        tr.updateAngle();
        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age >0){
          ret.add(tr);
        }
        else {
          ret.add(tr.rotationModule);
        }
        return ret;
      }
    });
    

    
    rules.put("MOVE", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        ArrayList<Module> ret = new  ArrayList<Module>();
        ret.add(m);
        return ret;
      }
    });
    
    
     //L : *  ->[{.-FI(7)+FI(7)+FI(7)}]
     //         [{.+FI(7)-FI(7)-FI(7)}]
    rules.put("L", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        float size = m.getP("size");

        ArrayList<Module> ret = new  ArrayList<Module>();
        float angle = radians(7);
        ret.add(new LBrack());
        ret.add(new Minus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Plus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Plus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new RBrack());
        
        ret.add(new LBrack());

        ret.add(new Plus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Minus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Minus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new RBrack());

        return ret;
      }
    });
    
    
    rules.put("K", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        ArrayList<Module> ret = new  ArrayList<Module>();
        float flowerSize=  10*size_factor;
        float flower_interval = m.getP("age");

        float angle = radians(18);
        ret.add(new Segment());
        ret.add(new LBrack());
        ret.add(new DelayModule(flower_interval, new TimedRotation(10.,radians(10.), new And(0))));
        ret.add(new LBrack());
        ret.add(new And(angle));
        ret.add(new Plus(angle));
        ret.add(new I(flowerSize));
        ret.add(new And(-angle));
        ret.add(new And(-(angle)));
        
        ret.add(new DelayModule(flower_interval, new TimedRotation(10.,angle/2, new And(0))));

        ret.add(new Minus(angle));
        ret.add(new Minus(angle));
        ret.add(new I(flowerSize));
        ret.add(new RBrack());
  
        ret.add(new LBrack());
        ret.add(new And(angle));
        ret.add(new Minus(angle));
        ret.add(new I(flowerSize));
        ret.add(new And(-angle));
        ret.add(new And(-(angle)));
        ret.add(new DelayModule(flower_interval, new TimedRotation(10.,angle/2, new And(0))));

        ret.add(new Plus(angle));
        ret.add(new Plus(angle));
        ret.add(new I(flowerSize));
        ret.add(new RBrack());
        
        ret.add(new RBrack());

        ret.add(new Slash(radians(360/6)));
        return ret;
      }
    });
    
     rules.put("K", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        ArrayList<Module> ret = new  ArrayList<Module>();
        float flowerSize=  10*size_factor;
        float flower_interval = m.getP("age");

        float angle = radians(18);
        ret.add(new Segment());
        ret.add(new LBrack());
        ret.add(new DelayModule(flower_interval, new TimedRotation(10.,radians(30.), new And(0))));
        ret.add(new And(angle));
        ret.add(new Plus(angle));
        ret.add(new I(flowerSize));
        ret.add(new Hat(angle));
        ret.add(new Hat(angle));
        ret.add(new I(flowerSize));

        ret.add(new DelayModule(flower_interval, new TimedRotation(10.,angle*2, new And(0))));

  
        ret.add(new Minus(radians(180)));
        ret.add(new And(radians(180)));
        ret.add(new Slash(radians(180)));

        ret.add(new Minus(angle));
        ret.add(new Hat(angle));
        ret.add(new I(flowerSize));
        
        //ret.add(new And(angle));
        //ret.add(new And(angle));
        //////ret.add(new DelayModule(flower_interval, new TimedRotation(10.,angle/2, new Hat(0))));
        //ret.add(new Plus(angle));
        ////ret.add(new Plus(angle));
        //ret.add(new I(flowerSize));
        
        ret.add(new RBrack());

        ret.add(new Slash(radians(360/6)));
        return ret;
      }
    });  
  }
}
