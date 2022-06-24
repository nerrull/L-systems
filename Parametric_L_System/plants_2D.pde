

class Plant2D extends ParametricLSystem{
  float angle, forward_length;
  int maxDepth, depth;
  color c;

  Plant2D(){
    float delta = random(11, 25);
    angle = radians(delta);
    maxDepth = 2;
    maxDepth = floor(random(2,4-0.00001));
    depth =0;
    c = colorPicker.getColor("GRASS");

    if (random(0,2) >1){
      word.add(new Rradial(radians(180)));
    }
    word.add(new Rradial(random(radians(-50),radians(50))));
    word.add(new X(0));
    wordTree.init(word.modules);
    defineRules();    
  }

  class X extends Module{
    X(float d){
      super("X");
      addParam("depth",d);
    }
  
    void drawFunction(){
    }
    
    String repr(){
      return "X";
    }
  }
  
  void defineRules(){   
    //"X => "F-[[X]+X]+F[+FX]-X"
    rules.put("X",new ParametricRule() {
      public  void rule(Module m,  ArrayList<Module> ret) { 
        float depth = m.getP("depth");
        float l = maxDepth*size_factor*2./(depth+1);
        if (depth>maxDepth){
          return;
        }
        ret.add(new Color (c, true, false));
        float r = random(0,1);
        if (r >0.5){
          ret.add(new BSlash(3*angle/(depth+1)));
        }
        else{
          ret.add(new Slash(3*angle/(depth+1)));
        }
        ret.add(new I(l)); 
        ret.add(new Minus(angle)); 
        ret.add(new LBrack()); 
        ret.add(new LBrack()); 
        ret.add(new DelayModule(random(0, l), new X(depth+1))); 
        ret.add(new RBrack());
        ret.add(new Plus(angle)); 
        ret.add(new DelayModule(random(0,l), new X(depth+1))); 
        ret.add(new RBrack());   
        ret.add(new Color (c, true, false));

        ret.add(new Plus(angle)); 
        ret.add(new I(l)); 
        ret.add(new LBrack()); 
        ret.add(new Plus(angle)); 
        ret.add(new Color (c, true, false));

        ret.add(new I(l)); 
        ret.add(new DelayModule(random(0,l), new X(depth+1))); 
        ret.add(new RBrack());
        
        ret.add(new Plus(angle)); 
        ret.add(new DelayModule(random(0,l), new X(depth+1))); 
      }
    });
  }   
}



class GrassPlant extends ParametricLSystem{
  float angle, forward_length;
  int maxDepth, depth;
  color c;
  
  GrassPlant(){
    float delta = random(11, 50);
    float leaf_size = random(4,10);
    maxDepth = 2;
    depth =0;
    word.add(new Rradial(random(radians(45))));
    
    c = colorPicker.getColor("GRASS");
    
    word.add(new LBrack());
    //word.add(new And(random(radians(12), radians(20))));
    word.add(new Leaf(20,random(leaf_size*2/3,leaf_size)));
    word.add(new RBrack());
    
    word.add(new Rradial(radians(137)));
    
    word.add(new LBrack());

    word.add(new And(random(radians(12), radians(20))));
    word.add(new Leaf(20,random(leaf_size*2/3,leaf_size)));
    word.add(new RBrack());
    
    word.add(new Rradial(radians(137)));
    word.add(new And(random(radians(12), radians(20))));
    word.add(new Leaf(20,random(leaf_size*2/3,leaf_size)));
    
    wordTree.init(word.modules);
    defineRules();    
  }

  class X extends Module{
    X(float d){
      super("X");
      addParam("depth",d);
    }
  
    void drawFunction(){
    }
    
    String repr(){
      return "X";
    }
  }
 void defineRules(){   
 rules.put("L", new ParametricRule() {
      public boolean rule(Module m,  ArrayList<Module> ret, boolean dirty) { 
        float age = m.getP("age");
        float size = m.getP("size");
        //ArrayList<Module> ret = new  ArrayList<Module>();
        float angle = radians(7);
        float extra_angle = angle - radians((angle/size));
        ret.add(new LBrack());
        ret.add(new Fill());
        ret.add(new Color (c, true, true));

        ret.add(new Minus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Plus(angle));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new F(.1));

        ret.add(new I(size));
        ret.add(new Plus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new RBrack());
        
        ret.add(new LBrack());
        ret.add(new Fill());
        ret.add(new Color (c, true, true));

        ret.add(new Plus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Minus(angle));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new Minus(angle));
        ret.add(new F(.1));
        ret.add(new I(size));
        ret.add(new RBrack());
        return true;
      }
    });
  }   
}



class SpiralPlant extends ParametricLSystem{
  float spiral_angle, forward_length;
  int maxDepth, depth;
  color c;

  SpiralPlant(){
    float delta = random(11, 50);
    spiral_angle= radians(2);
    maxDepth = 2;
    maxDepth = floor(random(2,5-0.0001));

    depth =0;
    c = colorPicker.getColor("WOOD");


    if (random(0,2) >1){
      word.add(new Rradial(radians(180)));
    }
    word.add(new Rradial(random(radians(-50),radians(50))));
    word.add(new SpiralI(20, 30, spiral_angle, 0.3));
    wordTree.init(word.modules);
    defineRules();    
  }

  class X extends Module{
    X(float d){
      super("X");
      addParam("depth",d);
    }
  
    void drawFunction(){
    }
    
    String repr(){
      return "X";
    }
  }
  class Spiral extends Module{
    Spiral( float size){
      super("Spiral");
      addParam("size",size);
    }
  
    void drawFunction(){
    }
    
    void drawFunction(PShape p){
      //p.curveVertex();
    }
    
    String repr(){
      return "X";
   }
  }
    
  class SpiralI extends Module{
    SpiralI(float age, float size, float angle, float odds){
      super("SpiralI");
      addParam("age",age);
      addParam("size",size);
      addParam("start_age", age);
      addParam("angle",angle);
      addParam("branching_odds",odds);
      addParam("start_odds",odds);

    }
    
    void drawFunction(){
    }
    
    void drawFunction(PShape p){
    }
    
    String repr(){
      return "X";
    }
  }
  
  void defineRules(){
    rules.put("SpiralI", new ParametricRule() {
      public boolean rule(Module m,  ArrayList<Module> ret, boolean dirty) { 
        float age = m.getP("age");
        float size = m.getP("size");
        float start_age = m.getP("start_age");
        float angle = m.getP("angle");
        float odds = m.getP("branching_odds");
        float start_odds = m.getP("start_odds");

        m.updateParam("age", age - growth_step);
        float seg_length = size/start_age;
        
        if (age >0){
          if (age - floor(age) <growth_step){
            ret.add(new Color (c, true, false));
            ret.add(new Plus(angle));
            ret.add(new I(seg_length));
            
            if (age < start_age*2/3){
              float r = random(0,1);
              if(r >(1.-odds)){
                 ret.add(new LBrack());
                 r = random(0,1);
                 if (r >0.5){
                   ret.add(new BSlash(angle*(start_age-age)));
                 }
                 else{
                    ret.add(new Slash(angle*(start_age-age)));
                 }
                 ret.add(new Minus(angle*(start_age-age)));
  
                 ret.add(new DelayModule(age/2+1, new SpiralI(start_age/2, size/2, -angle*1.5, odds/2)));
                 ret.add(new RBrack());       
                 m.updateParam("odds", max( 0, odds - start_odds/3));
              }
            }
            ret.add(m);

            return true;
          }
          else{
            ret.add(m);
          }
        }
        
        else {
            ret.add(new Slash(angle));
            ret.add(new I(seg_length));
            return true;
       }
       return false;
      }
    });
  }
}
