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
      public void rule(Module m, ArrayList<Module> ret) { 
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
    //super.update();
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
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        
        
        if (age <terminal_age){
          m.updateParam("age", age+timeStep);
          ret.add(m);
        }
        else{
          ret.add(new Al(forward_length, 0,2));
          //ret.add(new LBrack());
          
          ret.add(new Ar(forward_length, 1,2));
          //ret.add(new RBrack());

        }
        
      };
    }); 
    
    //"Ar(2)"-> "Al(1)Ar(0)");
    rules.put("Ar", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        
        if (age<terminal_age){
          m.updateParam("age", age+timeStep);
          ret.add(m);
        }
        else{
          m.updateParam("age", time);
          ret.add(new Al(forward_length, 1,2));
          ret.add(new Ar(forward_length, 0,2));
        }
        
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
    word.add(new A(forward_length,0,2));
  }
  
  void update(){
    //super.update();
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
      this.updateParam("current_length", d);
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
        this.updateParam("current_length", d);
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
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        float Aa = m.getP("distance");

        
        if (age <terminal_age){
          m.updateParam("age", age+timeStep);
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
        
      };
    }); 
    
    // (b, β) → (a, 0)
    rules.put("B", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        
        if (age<terminal_age){
          m.updateParam("age", age+timeStep);
          ret.add(m);
        }
        else{
          ret.add(new A(forward_length, 0,1));
        }
        
      };
    }); 
    rules.put("S", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");
        float terminal_age = m.getP("terminal");
        
        if (age<terminal_age){
          m.updateParam("age", age+timeStep);
          ret.add(m);
        }
        else{
          m.updateParam("age", age+timeStep);
          ret.add(m);
        }
        
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
    //super.update();
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
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");

        
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
        
      }
    });

      
    rules.put("L", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");

        
        if (age <Tl){
          ret.add(new Leaf(age +1));
        }
        else {
          ret.add(m);
        }
        
      }
    });

      
    rules.put("K", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float age = m.getP("age");

        
        if (age <Tk){
          ret.add(new Flower(age +1));
        }
        else {
          ret.add(m);
        }
        
      }
    });
 
    rules.put("F", new ParametricRule() {
      public void rule(Module m, ArrayList<Module> ret) { 
        float d = m.getP("distance");

        
        if (d <2){
          ret.add(new F(d +0.2));
        }
        else {
          ret.add(m);
        }
        
        
      };
    }); 
  }
}
