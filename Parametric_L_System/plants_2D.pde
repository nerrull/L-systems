

class Plant2D extends ParametricLSystem{
  float angle, forward_length;
  int maxDepth, depth;
  Plant2D(){
    angle = 22.5/180.*PI;
    forward_length = -4.;
    maxDepth = 4;
    depth =0;
    word.add(new Segment()); 
    word.add(new X(0));
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
    //"X => "F+[[X]-X]-F[-FX]+X"
    rules.put("X",new ParametricRule() {
      public ArrayList<Module> rule(Module m) { 
        ArrayList<Module> ret = new  ArrayList<Module>();
        float depth = m.getP("depth");
        if (depth>maxDepth){
          return ret;
        }
        ret.add(new Segment()); 
        ret.add(new I(10)); 
        ret.add(new Minus(angle)); 
        ret.add(new LBrack()); 
        ret.add(new LBrack()); 
        ret.add(new DelayModule(10, new X(depth+1))); 
        ret.add(new RBrack());
        ret.add(new Plus(angle)); 
        ret.add(new DelayModule(10, new X(depth+1))); 
        ret.add(new RBrack());   
        
        ret.add(new Plus(angle)); 
        ret.add(new I(10)); 
        ret.add(new LBrack()); 
        ret.add(new Plus(angle)); 
        ret.add(new I(10)); 
        ret.add(new DelayModule(10, new X(depth+1))); 
        ret.add(new RBrack());
        
        ret.add(new Minus(angle)); 
        ret.add(new DelayModule(10, new X(depth+1))); 
        return ret;

      }
    });
    //rules.put("F", new ParametricRule() {
    //  public ArrayList<Module> rule(Module m) { 
    //    ArrayList<Module> ret = new  ArrayList<Module>();
    //    ret.add(new F(1)); 
    //    return ret;
    //  }
    //});
  }
  
    
 
}
