
class Tulip extends ParametricLSystem{

  float angle,angle2, forward_length, time, timeStep;
  int n_leaves;
  int leaf_size;
  int leaf_interval_mean;
  float leaf_interval;
  float leaf_angle, angle_variance;
  color stem_color, flower_color, leaf_color, leaf_tip_color;
  Tulip(){

    angle = radians(30);
    angle2 = radians(137.5);
    growth_step = 0.1;
    size_factor =1.;
    int num_leaves  = 3 ;
    leaf_size = 12;
    leaf_interval_mean = 6;
    leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2);
    axial_range = radians(2);
    radial_range = radians(10);
    
    leaf_angle= 20;
    angle_variance = 3;
    defineRules();    
    stem_color = colorPicker.getColor("STEM");
    flower_color = colorPicker.getColor("TULIP");
    leaf_color = colorPicker.getColor("LEAF");
    leaf_tip_color = colorPicker.getColor("LEAF_TIP");

    word = new Word();
    word.add(new Segment());
    word.add(new Color(stem_color, true, false));
    //word.add(new Rradial(radians(90)));
    word.add(new Rradial(random(radians(10),radians(50))));
    if (random(0,1) >0.5){
      word.add(new Rradial(radians(180)));
    }
    word.add(new I(1));
    word.add(new A(num_leaves));
    wordTree.init(word.modules);
    
  }
  
  void setGrowthRate(float g){
    this.growth_step= g;
    axial_range = radians(10)*growth_step;
    radial_range = radians(10)*growth_step;
  }

  

  
  class A extends Module{
    A( float age){
      super("a");
      addParam("age", age);
    }
    
    String repr(){
      return "a" +"("+getP("age")+")";
    }
  }
  
  class BigA extends Module{
    BigA( ){
      super("A");
    }
  
    String repr(){
      return "A" ;
    }
  }
  
  
 class K extends Module{
    K(float age){
      super("K");
      this.addParam("age", age);
    }
    
    String repr(){
      return "K";
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
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");
        leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2)*size_factor;
        float la=  leaf_angle + random(- angle_variance, angle_variance);

        if (age <=0){
          ret.add(new Slash(radians(137.5)));         
          ret.add(new DelayModule(5, new BigA()));
        }
        else if (age >0){
          if (age - floor(age) < growth_step){
            n_leaves +=1;
            ret.add(new Segment());
            ret.add(new Color(stem_color, true, false));
            ret.add(new LBrack());
            ret.add(new And(radians(3)));
            ret.add(new DelayModule(5, new TimedRotation(20.,radians(la), new And(0))));
            ret.add(new Leaf(0, getLeafSize()));
            ret.add(new RBrack());
            
            ret.add(new Segment());
            ret.add(new Color(stem_color, true,false));
            ret.add(new Slash(radians(180)));
            ret.add(new IR(leaf_interval));
            
          }
          ret.add(new A(age -growth_step));
        }
      }
    });


    //[&(18)u(4)FFI(10)I(5)X(5)KKKK]/(137.5)I(8)A
    rules.put("A", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2);
        float flower_interval = random(25, 35)*size_factor;
       
        ret.add(new LBrack());
        //ret.add(new Move());
        ret.add(new Color(stem_color, true, false));
        ret.add(new IR(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new K(flower_interval));
        ret.add(new EndCut());
        ret.add(new RBrack());
      }
    });
    
   
     
    rules.put("MOVE", new ParametricRule() {
      public void rule(Module m,  ArrayList<Module> ret) { 
        //ArrayList<Module> ret = new  ArrayList<Module>();
        ret.add(m);
        //;
      }
    });
    
    
     //L : *  ->[{.-FI(7)+FI(7)+FI(7)}]
     //         [{.+FI(7)-FI(7)-FI(7)}]
    rules.put("L", new ParametricRule() {
      public boolean rule(Module m,  ArrayList<Module> ret, float growth_rate) { 
        float age = m.getP("age");
        float size = m.getP("size");
        //ArrayList<Module> ret = new  ArrayList<Module>();
        float angle = radians(7);
        float extra_angle = angle/2 - radians(((angle/2)/size));
        ret.add(new LBrack());
        ret.add(new Fill());
        ret.add(new Color(leaf_color, true, true));
        ret.add(new Minus(angle));
        ret.add(new TimedRotation(size/1.5,extra_angle, new Minus(0)));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Plus(angle));
        ret.add(new TimedRotation(size/1.5,extra_angle, new Plus(0)));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new F(.1));

        ret.add(new I(size));
        ret.add(new Plus(angle));
        ret.add(new TimedRotation(size/1.5,extra_angle, new Plus(0)));
        ret.add(new F(.1));
        ret.add(new Color(leaf_tip_color, true, true));
        ret.add(new I(size));
        ret.add(new RBrack());
        
        ret.add(new LBrack());
        ret.add(new Fill());
        ret.add(new Color(leaf_color, true, true));
        ret.add(new Plus(angle));
        ret.add(new TimedRotation(size/1.5,extra_angle, new Plus(0)));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Minus(angle));
        ret.add(new TimedRotation(size/1.5,extra_angle, new Minus(0)));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Minus(angle));
        ret.add(new TimedRotation(size/1.5,extra_angle, new Minus(0)));
        ret.add(new F(.1));
        ret.add(new Color(leaf_tip_color, true, true));

        ret.add(new I(size));
        ret.add(new RBrack());
        return true;
      }
    });
    
    
    rules.put("K", new ParametricRule() {
      public boolean rule(Module m, ArrayList<Module> ret, boolean dirty) { 
        //ArrayList<Module> ret = new  ArrayList<Module>();
        float flowerSize=  5*size_factor;
        float flower_interval = m.getP("age");

        float angle = radians(18);

        
        ret.add(new LBrack());
        ret.add(new Fill());
        ret.add(new Color(stem_color, true, true));
        ret.add(new Exclamation(0.1));
        ret.add(new DelayModule(flower_interval, new TimedRotation(10.,radians(15.), new And(0))));
        ret.add(new And(angle));
        ret.add(new Plus(angle));
        ret.add(new I(flowerSize/2));
        ret.add(new Color(flower_color, true, true));
        ret.add(new DelayModule(flower_interval, new I(flowerSize/2)));
        ret.add(new And(-angle));
        ret.add(new And(-(angle)));
        ret.add(new DelayModule(flower_interval, new TimedRotation(10., angle/2, new And(0))));
        ret.add(new Minus(angle));
        ret.add(new Minus(angle));
        ret.add(new I(flowerSize/2));
        ret.add(new DelayModule(flower_interval, new I(flowerSize/2)));
        ret.add(new RBrack());
 
        ret.add(new LBrack());
        ret.add(new Fill());
        ret.add(new Exclamation(0.1));
        ret.add(new Color(stem_color, true, true));
        ret.add(new DelayModule(flower_interval, new TimedRotation(10.,radians(15.), new And(0))));
        ret.add(new And(angle));
        ret.add(new Minus(angle));
        ret.add(new I(flowerSize/2));
        ret.add(new Color(flower_color, true, true));
        ret.add(new DelayModule(flower_interval, new I(flowerSize/2)));
        ret.add(new And(-angle));
        ret.add(new And(-(angle)));
        ret.add(new DelayModule(flower_interval, new TimedRotation(10.,angle/2, new And(0))));
        ret.add(new Plus(angle));
        ret.add(new Plus(angle));
        ret.add(new I(flowerSize/2));
        ret.add(new DelayModule(flower_interval, new I(flowerSize/2)));
        ret.add(new RBrack());
        
        ret.add(new Slash(radians(360/6)));
        return true;
      }
      
    });
    
    rules.put("MERGE", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
      }
    });
  }
}
