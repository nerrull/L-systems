
class LychnisCoronaria extends ParametricLSystem{

  float angle,angle2, forward_length, time, timeStep;
  float Ta, Tl, Tk;
  float growth_step, axial_range, radial_range;
  int n_flowers, max_flowers;
  int leaf_size;
  int leaf_interval_mean;
  float leaf_interval;
  float size_factor;
  float leaf_angle, angle_variance;
  
  LychnisCoronaria(){
    Ta =7;
    Tl =9;
    Tk=5;
    angle = radians(30);
    angle2 = radians(137.5);
    growth_step = 0.1;
    size_factor =1.;
    n_flowers = 0;
    max_flowers =(int) random(2,5);
    int num_leaves  =(int) random(2,10);
    this.timeStep = 0.05;
    leaf_size = 4;
    leaf_interval_mean = 9;
    leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2);
    axial_range = radians(10)*growth_step;
    radial_range = radians(10)*growth_step;
    
    leaf_angle= 70;
    angle_variance = 10;
    
    defineRules();
    word = new Word();
    word.add(new Segment());
    word.add(new Green());
    word.add(new Rradial(random(0,radians(360))));
    word.add(new A(7));

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
      super("A");
      addParam("age", age);
    }
  
    void drawFunction(){
    }
    
    String repr(){
      return "A" +"("+getP("age")+")";
    }
  }
  
  class U extends Module{
    U( float age, float angle){
      super("u");
      addParam("age", age);
      addParam("angle", angle);

    }
    
    String repr(){
      return "u" +"("+getP("age")+")";
    }
  }
  
  
  
  class Leaf extends Module{
    Leaf( float age, float size){
      super("L");
      addParam("age", age);
      addParam("size", size);

    }
    
    String repr(){
      return "L" +"("+getP("age")+ "," +getP("size")+")";
    }
  }
  
 class K extends Module{
    K(){
      super("K");
    }

    String repr(){
      return "K";
    }
  }
  
  class DelayedFlower extends Module{
    DelayedFlower(float age){
      super("D");
      this.addParam("age", age);
    }

    String repr(){
      return "D";
    }
  }
  
  
 class I extends Module{
    I(float age){
      super("I");
      addParam("age", age);

    }
    
    String repr(){
      return "I" +"("+getP("age")+")";
    }
    
    Module grow(){
      return this;
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


  
  void defineRules(){   
    // a(t) : t>0 → [&(70)L]/(137.5)I(10)a(t-1)
    // a(t) : t=0 → [&(70)L]/(137.5)I(10)A

    rules.put("A", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2);
        float flower_interval = random(3, 6)*size_factor;
        float age = m.getP("age");
        
        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age<7.){
          println(age+timeStep);
          ret.add(new A(age+timeStep));
        }
        else{
          ret.add(new Segment());
          ret.add(new Green());
          ret.add(new I(20));
  
          ret.add(new LBrack());
          ret.add(new And(radians(60)));
          ret.add(new Leaf(0, leaf_size));
          ret.add(new RBrack());
          
          word.add(new Segment());
          ret.add(new Slash(radians(90)));
          ret.add(new LBrack());
          ret.add(new And(radians(45)));
          ret.add(new A(0.));
          ret.add(new RBrack());
          
          word.add(new Segment());
          ret.add(new Slash(radians(90)));
          ret.add(new LBrack());
          ret.add(new And(radians(60)));
          ret.add(new Leaf(0, leaf_size));
          ret.add(new RBrack());
          
          
          word.add(new Segment());
          ret.add(new Slash(radians(90)));
          ret.add(new LBrack());
          ret.add(new And(radians(45)));
          ret.add(new A(4.));
          ret.add(new RBrack());
                    
          word.add(new Segment());
          ret.add(new Slash(radians(90)));
          ret.add(new I(10));
          ret.add(new DelayedFlower(10));
      
        }
        return ret;
      }
    });
    
    rules.put("I", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age >0){
         
          ret.add(new F(growth_step));
          ret.add(new I(age-growth_step));
        }
        else {
          ret.add(new F(growth_step));
        }
        return ret;
      }
    });
    
    rules.put("IR", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age >0){
          ret.add(new Raxial(random(-axial_range, axial_range)));
          ret.add(new Rradial(random(-radial_range, radial_range)));
          
          ret.add(new F(growth_step));
          ret.add(new IR(age-growth_step));
        }
        else {
          ret.add(new F(growth_step));
        }
        return ret;
      }
    });
    
    rules.put("D", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age >0){
          ret.add(new DelayedFlower(age-growth_step));
        }
        else {
          if (n_flowers >max_flowers){
            return ret;
          }
          ret.add(new K());
          n_flowers ++;

        }
        return ret;
      }
    });
    
   rules.put("u", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        float angle = m.getP("angle");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age >0){
          ret.add(new And(radians(angle*growth_step)));
          ret.add(new U(age-growth_step, angle));
        }
        return ret;
      }
    });
    rules.put("MERGE", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        return new  ArrayList<Module>();
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
        float flowerSize=  3*size_factor;
        float angle = radians(18);
        ret.add(new LBrack());
        ret.add(new Purple());
        ret.add(new And(angle));
        ret.add(new Plus(angle));
        //ret.add(new F(1));
        ret.add(new I(flowerSize));
        ret.add(new Minus(angle));
        ret.add(new Minus(angle));
        //ret.add(new F(1));
        ret.add(new I(flowerSize));
        ret.add(new RBrack());
        
        ret.add(new LBrack());
        ret.add(new Purple());
        ret.add(new And(angle));
        ret.add(new Minus(angle));
        //ret.add(new F(1));
        ret.add(new I(flowerSize));
        ret.add(new Plus(angle));
        ret.add(new Plus(angle));
        //ret.add(new F(1));
        ret.add(new I(flowerSize));
        ret.add(new RBrack());
        ret.add(new Slash(radians(90)));
        return ret;
      }
    });
      
 
  }
}
