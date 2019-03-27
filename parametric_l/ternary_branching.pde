
//p.56
class Ternary extends ParametricLSystem{
  
  class A extends Module{
    A(){
      super("A", new float[] {});
    }
  
    void drawFunction(){
    }
  }
  
  //parameters 
  float a,d1,d2,wr, vr, lr;
  float initWidth = 1./10;
  
  Ternary(){
    a = radians(18.95);
    d1 = radians(94.74);
    d2 = radians(132.63);
    lr = 1.109;
    vr = 1.73;
    word = new Word();
    word.add(new Exclamation(initWidth));
    word.add(new F(50));
    word.add(new Slash(radians(45)));
    word.add(new A());
    
    turtle.setTropism(new PVector(0,0,-1.), 0.0);
    defineRules();
  }
  
  int nVariants =4;
  void setVariant(int idx){
    PVector T;
    float e;
    switch (idx){
      case 0:
        d1= radians(137.5);
        d2 = radians(137.5);
        a = radians(18.95); 
        lr = 1.109;
        T = new PVector(0, -1., 0.);
        e= 0.14;
        turtle.setTropism(T,e);
      break;
      case 1:
        d1 = radians(112.5);
        d2 = radians(157.63);
        a = radians(22.5); 
        lr = 1.079;
        T = new PVector(-0.02, -1., 0);
        e= 0.27;
        turtle.setTropism(T,e);
      break;
      case 2:
        d1 = radians(180.);
        d2 = radians(252.);
        a = radians(36.); 
        lr = 1.07;
        T = new PVector(-0.61, .77, -0.19);
        e= 0.4;
        turtle.setTropism(T,e);
      break;
      default:
      break;
    }
    
  }
  
  
  void defineRules(){
    
    //A:*→ !(vr)F(50)[&(a)F(50)A]/(d1)
    //     [&(a)F(50)A]/(d2)[&(a)F(50)A]
    rules.put("A", new ParametricRule() {
        public ArrayList<Module> rule(Module m) { 
            ArrayList<Module> ret = new  ArrayList<Module>();
            ret.add(new Exclamation(initWidth*vr));
            ret.add(new F(50));
            ret.add(new LBrack());
            ret.add(new And(a));
            ret.add(new F(50));
            ret.add(new A());
            ret.add(new RBrack());
            ret.add(new Slash(d1));
            ret.add(new LBrack());
            ret.add(new And(a));
            ret.add(new F(50));
            ret.add(new A());
            ret.add(new RBrack());
            ret.add(new Slash(d2));
            ret.add(new LBrack());
            ret.add(new And(a));
            ret.add(new F(50));
            ret.add(new A());
            ret.add(new RBrack());
           return ret;
        };
    });
    
    //F(l) :  *→F(l*lr)
    rules.put("F", new ParametricRule() {
        public ArrayList<Module> rule(Module m) { 
            float l = m.getP(0);
            ArrayList<Module> ret = new  ArrayList<Module>();
            ret.add(new F(l*lr));
           return ret;
        };
    });
    
    //!(w) :  *→!(w*vr)
    rules.put("!", new ParametricRule() {
        public ArrayList<Module> rule(Module m) { 
            float w = m.getP(0);
            ArrayList<Module> ret = new  ArrayList<Module>();
            ret.add(new Exclamation(w*vr));
           return ret;
        };
    });
    
  }
}

class CircularTernary extends Ternary{
  
  CircularTernary(){
    a = radians(18.95);
    d1 = radians(94.74);
    d2 = radians(132.63);
    lr = 1.109;
    vr = 1.73;
    word = new Word();
    word.add(new Exclamation(initWidth));
    word.add(new LBrack());
    word.add(new A());
    word.add(new RBrack());
    word.add(new Plus(radians(60)));
    word.add(new LBrack());
    word.add(new A());
    word.add(new RBrack());
    word.add(new Plus(radians(60)));
    word.add(new LBrack());
    word.add(new A());
    word.add(new RBrack());
    word.add(new Plus(radians(60)));
    word.add(new LBrack());
    word.add(new A());
    word.add(new RBrack());
    word.add(new Plus(radians(60)));
    word.add(new LBrack());
    word.add(new A());
    word.add(new RBrack());
    word.add(new Plus(radians(60)));
    word.add(new LBrack());
    word.add(new A());
    word.add(new RBrack());

    turtle.setTropism(new PVector(0,0,-1.), 0.0);
    defineRules();
  }

}
