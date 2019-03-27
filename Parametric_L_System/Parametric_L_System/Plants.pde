
class SimplePlant extends ParametricLSystem{
  float angle, forward_length;
  
  SimplePlant(){
    angle = 25.7/180.*PI;
    forward_length = 4.;
    defineRules();
    defineRules();
    word = new Word();
    word.add(new F(forward_length));
  }
  
  void defineRules(){   
    //"F"-> "F[+F]F[-F]F");
    rules.put("F", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        ArrayList<Module> ret = new  ArrayList<Module>();
        ret.add(new F(forward_length));
        ret.add(new LBrack());
        ret.add(new Plus(angle));
        ret.add(new F(forward_length));
        ret.add(new RBrack());
        ret.add(new F(forward_length));
        ret.add(new LBrack());
        ret.add(new Minus(angle));
        ret.add(new F(forward_length));
        ret.add(new RBrack());
        ret.add(new F(forward_length));
        return ret;
      };
    }); 
  }
}


float growthB = 0.4812;
class SimpleGrowingPlant extends ParametricLSystem{
  float angle, forward_length, time, timeStep;
  
  SimpleGrowingPlant(){
    angle = 25.7/180.*PI;
    forward_length = 1.;
    timeStep = 1./60.;
    defineRules();
    defineRules();
    word = new Word();
    word.add(new Ar(forward_length,0,2));
  }
  
  void update(){
    super.update();
    time +=timeStep;
  }  
  
  class Ar extends Module{
    Ar( float d, float age, float terminal){
      super("Ar");
      addParam("distance", d);
      addParam("age", age);
      addParam("terminal", terminal);
    }
  
    void drawFunction(){
      stroke(255,0,0);
      float d = getP("distance") *exp(growthB*getP("age"));
      turtle.forward(d);
    }
    
    String repr(){
      return "Ar" +"("+getP("age")+")";
    }
  }
  
  class Al extends Module{
    Al( float d, float age, float terminal){
      super("Al");
      addParam("distance", d);
      addParam("age", age);
      addParam("terminal", terminal);
    }
  
    void drawFunction(){
      stroke(0,255,0);
      float d = getP("distance") *exp(growthB*getP("age"));
      turtle.forward(d);
    }
    String repr(){
      return "Al" +"("+getP("age")+")";
    }
  }
  
  void defineRules(){   
    //"Al(2)"-> "Al(0)Ar(1)");
    rules.put("Al", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        
        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age <terminal_age){
          m.updateParameter("age", age+timeStep);
          ret.add(m);
        }
        else{
          ret.add(new Al(forward_length, 0,2));
          //ret.add(new LBrack());
          
          ret.add(new Ar(forward_length, 1,2));
          //ret.add(new RBrack());

        }
        return ret;
      };
    }); 
    
    //"Ar(2)"-> "Al(1)Ar(0)");
    rules.put("Ar", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age<terminal_age){
          m.updateParameter("age", age+timeStep);
          ret.add(m);
        }
        else{
          m.updateParameter("age", time);
          ret.add(new Al(forward_length, 1,2));
          ret.add(new Ar(forward_length, 0,2));
        }
        return ret;
      };
    }); 
  }
}

class SimpleBranchingPlant extends ParametricLSystem{
  float angle, forward_length, time, timeStep;
  
  SimpleBranchingPlant(){
    angle = 25.7/180.*PI;
    forward_length = 4.;
    timeStep = 1./60.;
    defineRules();
    word = new Word();
    word.add(new A(forward_length,0,2));
  }
  
  void update(){
    super.update();
    time +=timeStep;
  }  
  
  class A extends Module{
    A( float d, float age, float terminal){
      super("A");
      addParam("distance", d);
      addParam("age", age);
      addParam("terminal", terminal);
      addParam("current_length", 0.);

    }
  
    void drawFunction(){
      stroke(255,0,0);
       turtle.forward(getP("current_length"));
    }
    
    Module grow(){
      float d = getP("distance") *exp(growthB*getP("age"));
      this.updateParameter("current_length", d);
      return this;
    }
    
    String repr(){
      return "A" +"("+getP("age")+")";
    }
  }
  
  class B extends Module{
    B( float d, float age, float terminal){
      super("B");
      addParam("distance", d);
      addParam("age", age);
      addParam("terminal", terminal);
      addParam("current_length", 1.);

    }
    
    void drawFunction(){
       turtle.forward(getP("current_length"));
    }
    
    Module grow(){
      if (getP("age") < getP("terminal")){
        float d = getP("distance")*(growthB-2)*pow(getP("age"),3)  + getP("distance")*(3-growthB)*pow(getP("age"),2);
        this.updateParameter("current_length", d);
      }
      return this;
    }
    
    String repr(){
      return "B" +"("+getP("age")+")";
    }
  }
  
  class S extends Module{
    S( float d, float age, float terminal){
      super("S");
      addParam("distance", d);
      addParam("age", age);
      addParam("terminal", terminal);
    }
  
    void drawFunction(){
      stroke(255,0,0);
      float d = getP("distance") *(1- exp(-growthB*getP("age")));
      //float d = getP("distance") *exp(growthB*getP("age"));
      turtle.forward(d);
    }
    String repr(){
      return "S" +"("+getP("age")+")";
    }
  }
  
  void defineRules(){   
    //(a, 1) → (s, 0)[(b, 0)][(b, 0)](a, 0)
    rules.put("A", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        float Aa = m.getP("distance");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age <terminal_age){
          m.updateParameter("age", age+timeStep);
          ret.add(m);
        }
        else{
          ret.add(new S(Aa*(exp(growthB)-1), 0,1));
          ret.add(new LBrack());
          ret.add(new Plus(angle));
          ret.add(new B(forward_length, 0,1));
          ret.add(new RBrack());
          ret.add(new LBrack());
          ret.add(new Minus(angle));
          ret.add(new B(forward_length, 0,1));
          ret.add(new RBrack());
          ret.add(new A(forward_length, 0,1));
        }
        return ret;
      };
    }); 
    
    // (b, β) → (a, 0)
    rules.put("B", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age<terminal_age){
          m.updateParameter("age", age+timeStep);
          ret.add(m);
        }
        else{
          ret.add(new A(forward_length, 0,1));
        }
        return ret;
      };
    }); 
    rules.put("S", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age<terminal_age){
          m.updateParameter("age", age+timeStep);
          ret.add(m);
        }
        else{
          m.updateParameter("age", age+timeStep);
          ret.add(m);
        }
        return ret;
      };
    }); 
  }
}

class Crocus extends ParametricLSystem{

  float angle,angle2, forward_length, time, timeStep;
  float Ta, Tl, Tk;
  
  Crocus(){
    Ta =7;
    Tl =9;
    Tk=5;
    angle = radians(30);
    angle2 = radians(137.5);

    defineRules();
    word = new Word();
    word.add(new A(1));
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
  
  class Leaf extends Module{
    Leaf( float age){
      super("L");
      addParam("age", age);
    }
  
    void drawFunction(){
      stroke(0,255,0);
      turtle.forward(getP("age"));
    }
    
    String repr(){
      return "L" +"("+getP("age")+")";
    }
  }
  
 class Flower extends Module{
    Flower( float age){
      super("K");
      addParam("age", age);
    }
  
    void drawFunction(){
      stroke(200, 4,180);
      sphere(getP("age")/3.);
    }
    
    String repr(){
      return "K" +"("+getP("age")+")";
    }
  }
  
  void defineRules(){   
    //(a, 1) → (s, 0)[(b, 0)][(b, 0)](a, 0)
    rules.put("A", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age <Ta){
          ret.add(new F(1));
          ret.add(new LBrack());
          ret.add(new And(angle));
          ret.add(new Leaf(0));
          ret.add(new RBrack());
          ret.add(new Slash(angle2));
          ret.add(new A(age+1));
        }
        else if (age ==Ta){
          ret.add(new F(5));
          ret.add(new Flower(0));
        }
        return ret;
      }
    });

      
    rules.put("L", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age <Tl){
          ret.add(new Leaf(age +1));
        }
        else {
          ret.add(m);
        }
        return ret;
      }
    });

      
    rules.put("K", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (age <Tk){
          ret.add(new Flower(age +1));
        }
        else {
          ret.add(m);
        }
        return ret;
      }
    });
 
    rules.put("F", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float d = m.getP("distance");

        ArrayList<Module> ret = new  ArrayList<Module>();
        if (d <2){
          ret.add(new F(d +0.2));
        }
        else {
          ret.add(m);
        }
        
        return ret;
      };
    }); 
  }
}


class SheperdsPurse extends ParametricLSystem{

  float angle,angle2, forward_length, time, timeStep;
  float Ta, Tl, Tk;
  float growth_step, axial_range, radial_range;
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
    max_flowers =(int) random(2,5);
    int num_leaves  =(int) random(2,10);
    
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
  
  class DelayedFlower extends Module{
    DelayedFlower(float age){
      super("D");
      this.addParam("age", age);
    }
    
    void drawFunction(){
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
  
    void drawFunction(){

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
  
    void drawFunction(){

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
          ret.add(new Segment());
          ret.add(new Green());
          ret.add(new LBrack());
          //ret.add(new And(angle_variance));
          ret.add(new U(4, la/4.));
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
            ret.add(new U(4, la/4.));
            ret.add(new Leaf(0, random(leaf_size -1,leaf_size +1)));
            ret.add(new RBrack());
            ret.add(new Segment());
            ret.add(new Green());
            ret.add(new Slash(radians(137.5)));
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
        float flower_interval = random(3, 6)*size_factor;

        ArrayList<Module> ret = new  ArrayList<Module>();
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
        ret.add(new Segment());
        ret.add(new Green()); 
        ret.add(new Slash(radians(137.5)));
        ret.add(new IR(flower_interval));
        ret.add(new DelayedFlower(10));
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
          ret.add(new BigA());
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
      
    rules.put("X", new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        float age = m.getP("age");

        ArrayList<Module> ret = new  ArrayList<Module>();
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
        return ret;
      }
    });
 
  }
}
