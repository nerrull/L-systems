
class SheperdsPurse extends ParametricLSystem{

  float angle,angle2, forward_length, time, timeStep;
  float Ta, Tl, Tk;
  int n_flowers, max_flowers;
  int leaf_size;
  int leaf_interval_mean;
  float leaf_interval;
  float size_factor;
  float leaf_angle, angle_variance;
  
  SheperdsPurse(){
    Ta =7;
    Tl =9;
    Tk=5;
    angle = radians(30);
    angle2 = radians(137.5);
    growth_step = 0.1;
    size_factor =1.;
    n_flowers = 0;
    max_flowers =(int) random(2,4);
    int num_leaves  =(int) random(2,6);
    
    leaf_size = 4;
    leaf_interval_mean = 9;
    leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2);
    axial_range = radians(10)*growth_step;
    radial_range = radians(10)*growth_step;
    
    leaf_angle= 55;
    angle_variance = 10;
    
    defineRules();
    word = new Word();
    word.add(new Segment());
    word.add(new Green());
    word.add(new Rradial(random(0,radians(360))));
    word.add(new I(leaf_interval));
    word.add(new A(num_leaves));
    wordTree.init(word.modules);

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
    //super.update();
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
  
  class U extends Module{
    U( float age, float angle){
      super("u");
      addParam("age", age);
      addParam("angle", angle);

    }
  
    void drawFunction(){
    }
    
    String repr(){
      return "u" +"("+getP("age")+")";
    }
  }
  
  
  class BigA extends Module{
    BigA( ){
      super("A");
      addParam("stem", 1.);

    }
    
    BigA( float stem){
      super("A");
      addParam("stem", stem);
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
    K(){
      super("K");
    }
    
    void drawFunction(){
    }
    
    String repr(){
      return "K";
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
  
  void defineRules(){   
    // a(t) : t>0 → [&(70)L]/(137.5)I(10)a(t-1)
    // a(t) : t=0 → [&(70)L]/(137.5)I(10)A

    rules.put("a", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");
        leaf_interval = random(leaf_interval_mean-2, leaf_interval_mean+2)*size_factor;
        float la=  radians(leaf_angle + random(- angle_variance, angle_variance));
        
        if (age <=0 ){
          ret.add(new Segment());
          ret.add(new Green());
          ret.add(new LBrack());
          //ret.add(new And(angle_variance));
          ret.add(new TimedRotation(10, la, new And(radians(3))));
          ret.add(new Leaf(0, random(leaf_size -1,leaf_size +1)));
          ret.add(new RBrack());
          ret.add(new Segment());
          ret.add(new Green());
          ret.add(new Slash(radians(137.5)));
          ret.add(new IR(leaf_interval));
          ret.add(new BigA());
        }
        
        else if (age >0){
          if (age - floor(age) < growth_step){

            ret.add(new Segment());
            ret.add(new Green());
            ret.add(new LBrack());
            //ret.add(new And(10));
            ret.add(new TimedRotation(10, la, new And(radians(3))));
            ret.add(new Leaf(0, random(leaf_size -1,leaf_size +1)));
            ret.add(new RBrack());
            ret.add(new Segment());
            ret.add(new Green());
            ret.add(new Slash(radians(137.5)));
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
        float stem = m.getP("stem");

        float flower_interval = random(3, 6)*size_factor*stem;

        n_flowers++;
        ret.add(new Segment());
        ret.add(new Green());
        ret.add(new LBrack());
        ret.add(new And(radians(18)));
        ret.add(new U(4,9));
        //ret.add(new F(1));
        //ret.add(new F(1));
        ret.add(new IR(flower_interval));
        //ret.add(new IR(5));
        //ret.add(new X(20));
        ret.add(new K());
        ret.add(new K());
        ret.add(new K());
        ret.add(new K());
        ret.add(new EndCut());
        ret.add(new RBrack());


        if (n_flowers<max_flowers)
        {       
          ret.add(new Segment());
          ret.add(new Green()); 
          ret.add(new Slash(radians(137.5)));
          ret.add(new IR(flower_interval));
          ret.add(new DelayModule(flower_interval+2, new BigA()));
        }
        if (n_flowers==max_flowers)
        {       
          ret.add(new Segment());
          ret.add(new Green()); 
          ret.add(new Slash(radians(137.5)));
          ret.add(new IR(flower_interval));
          ret.add(new DelayModule(flower_interval, new BigA(0)));
        }
        
      }
    });
    
   rules.put("u", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");
        float angle = m.getP("angle");

        
        if (age >0){
          ret.add(new And(radians(angle*growth_step)));
          ret.add(new U(age-growth_step, angle));
        }
        
      }
    });
    
    rules.put("MERGE", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
      }
    });
     //L : *  ->[{.-FI(7)+FI(7)+FI(7)}]
     //         [{.+FI(7)-FI(7)-FI(7)}]
    rules.put("L", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");
        float size = m.getP("size");

        float angle = radians(7);
        ret.add(new LBrack());
        ret.add(new Fill());
        ret.add(new White());
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
        ret.add(new Fill());
        ret.add(new White());
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

        
      }
    });
    
    rules.put("K", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float flowerSize=  3*size_factor;
        float angle = radians(18);
        ret.add(new LBrack());
        ret.add(new Fill());
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
        ret.add(new Fill());
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

      }
    });
      
    rules.put("X", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");

        
        if (age >0){
          ret.add(new X(age -growth_step));
        }
        else {
          ret.add(new Hat(radians(50)));
          ret.add(new LBrack());
          ret.add(new Orange());
          ret.add(new Minus(angle));
          ret.add(new F(1));
          ret.add(new IR(7));
          ret.add(new Plus(angle));
          ret.add(new F(1));
          ret.add(new IR(2));
          ret.add(new Plus(angle));
          ret.add(new F(1));
          ret.add(new IR(2));
          ret.add(new RBrack());
          
          ret.add(new LBrack());
          ret.add(new Orange()); 
          ret.add(new Plus(angle));
          ret.add(new F(1));
          ret.add(new I(2));
          ret.add(new Minus(angle));
          ret.add(new F(1));
          ret.add(new I(2));
          ret.add(new Minus(angle));
          ret.add(new F(1));
          ret.add(new I(7));
          ret.add(new RBrack());
          ret.add(new Cut());
        }
        
      }
    });
  }
}
