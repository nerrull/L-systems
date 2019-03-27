class Spiral extends ParametricLSystem{
  float angle, lr, wr;
  Spiral(){
    angle=  radians(10);
    wr = 0.98;
    lr =1.02;
    this.word = new Word();
    this.word.add(new A(10,5,0,angle));

    this.defineRules();
  }
  
  class A extends Module{
    A(float p1, float p2, float p3, float p4){
      super("A", new float[] {p1,p2, p3,p4});
    }
  
    void drawFunction(){
      
    }
  }
  
   void defineRules(){
    // A(w, l) : *→ !(w)F(l)[+(a)A(l*lr, w*wr)]
    rules.put("A", new ParametricRule() {
        public ArrayList<Module> rule(Module m) { 
            float w = m.getP(1);
            float l = m.getP(0);
            float age = m.getP(2);
            float angle = m.getP(3);
            ArrayList<Module> ret = new  ArrayList<Module>();
            ret.add(new Exclamation(w));
            ret.add(new F(l));
            ret.add(new Plus(angle));
            if (age %10 ==0){
              ret.add(new LBrack());
              ret.add(new A(l*lr, w*wr, age+1, -angle ));
              ret.add(new RBrack());

            }
            
            ret.add(new A(l*lr, w*wr, age+1, angle ));
            
   
           return ret;
        };
    });
  }
}
