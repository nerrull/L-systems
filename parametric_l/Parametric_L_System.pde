
PVector orientation;

static interface ParametricRule {
    ArrayList<Module> rule(Module m);
}


class Module{
  String letter;
  float[] parameters;
  
  Module(String l){
    letter = l;
  }
  Module(String l, float[] p){
    letter = l;
    parameters = p;
  }
  
  void drawFunction(){
    return;
  }
  
  float getP(){
    return parameters[0];
  }
  float getP(int i){
    return parameters[i];
  }
  
  String repr(){
    return this.letter;
  }
    
}

class Word{
  ArrayList<Module> modules;
  Word(){
    modules=  new ArrayList<Module>();
  }
  
  void add(ArrayList<Module> m){
    modules.addAll(m);
  }
  
  void add(Module m){
    modules.add(m);
  }
  void clear(){
    modules.clear();
  }
}

class F extends Module{
  F( float p){
    super("F", new float[] {p});
  }

  void drawFunction(){
    turtle.forward(getP());

  }
  String repr(){
    return "F" +"("+getP()+")";
  }
}

class Plus extends Module{
  Plus( float p){
    super("+", new float[] {p});
  }

  void drawFunction(){
    //rotateZ(parameters[0]);
    turtle.Ru(getP());
  }
}

class Minus extends Module{
  Minus( float p){
    super("-", new float[] {p});
  }

  void drawFunction(){
    turtle.Ru(-getP());
  }
}

class Hat extends Module{
  Hat( float p){
    super("^", new float[] {p});
  }

  void drawFunction(){
    turtle.Rl(-getP());
  }
}
class And extends Module{
  And( float p){
    super("&", new float[] {p});
  }
  
  void drawFunction(){
     turtle.Rl(getP());
  }
}

class Slash extends Module{
  Slash( float p){
    super("/", new float[] {p});
  }

  void drawFunction(){
    turtle.Rh(-getP());
  }
}
class BSlash extends Module{
  BSlash( float p){
    super("\\", new float[] {p});
  }

  void drawFunction(){
    turtle.Rh(getP());
  }
}
class Turn180 extends Module{
  Turn180( float p){
    super("|", new float[] {p});
  }

  void drawFunction(){
    turtle.Ru(radians(180));
  }
}

class Move extends Module{
  Move(float p){
    super("f", new float[] {p});
  }

  void drawFunction(){
    translate(0,parameters[0]);
  }
}

class LBrack extends Module{
  LBrack(){
    super("[");
  }

  void drawFunction(){
    pushMatrix();
    pushStyle();

    turtle.push();
  }
  
}
class RBrack extends Module{
  RBrack(){
    super("]");
  }

  void drawFunction(){
    popMatrix();
    popStyle();
    turtle.pop();
  }
}

class Dollar extends Module{
  Dollar(){
    super("$");
  }

  void drawFunction(){
    //Find way to rotate so that left is hhorizontal
    turtle.reorientHorizontal();
  }
}

class Exclamation extends Module{
  Exclamation(float p){
    super("!", new float[] {p});
  }

  void drawFunction(){
    strokeWeight(this.getP());
  }
  
  String repr(){
    return "!" + "(" +this.getP() +")";
  }
}

class ParametricLSystem{
  
  HashMap<String, ParametricRule> rules;
  Word word;
  float xPos = 0;
  float yPos = 0;
  
  ParametricLSystem(){
     rules = new HashMap<String, ParametricRule>();
  }
  
  void update(){
    Word newWord=  new Word();
    for(Module m : word.modules){
      if(rules.containsKey(m.letter)){
        newWord.add(rules.get(m.letter).rule(m));
      }
      else{
         newWord.add(m);
      }
    }
    word = newWord;
  }
  
  void drawSystem(){
    pushMatrix();
    pushStyle();
    translate(xPos, yPos);
    for(Module m : word.modules){
       m.drawFunction();
    }
    popStyle();
    popMatrix();
  }
  
  void repr(){
    println();
     for(Module m : word.modules){
       print(m.repr());
     }
  }
  void defineRules(){
    throw( new  java.lang.UnsupportedOperationException());
  }
  
  void setVariant(int i){
  }
  
  void setPosition(float px,float py){
    this.xPos = px;
    this.yPos =py;
  }
}

class RowOfTrees extends ParametricLSystem{
  //parameters 
  float c,p,q,h;
  float rot;
  
  RowOfTrees(){
    c=1;
    p= 0.3;
    q= c-p;
    h = pow((p*q),0.5);
    rot = 86./180.*PI;
    word = new Word();
    word.add(new F(50));
    defineRules();
  }
  
  void defineRules(){
    //F(x)→F(x*p)+F(x*h)−−F(x*h)+F(x*q)
    rules.put("F", new ParametricRule() {
        public ArrayList<Module> rule(Module m) { 
           ArrayList<Module> ret = new  ArrayList<Module>();
           ret.add(new F(m.getP()*p));
           ret.add(new Plus(rot));
           ret.add(new F(m.getP()*h));
           ret.add(new Minus(rot));
           ret.add(new Minus(rot));
           ret.add(new F(m.getP()*h));
           ret.add(new Plus(rot));
           ret.add(new F(m.getP()*q));
           return ret;
        };
    });
  }
}


//p.56
class Tree extends ParametricLSystem{
  
  class A extends Module{
    A(float p1, float p2){
      super("A", new float[] {p1,p2});
    }
  
    void drawFunction(){
      
    }
  }
  class B extends Module{
    B(float p1, float p2){
      super("B", new float[] {p1,p2});
    }
  
    void drawFunction(){
      
    }
  }

  class C extends Module{
    C(float p1, float p2){
      super("C", new float[] {p1,p2});
    }
  
    void drawFunction(){
      
    }
  }
  
  //parameters 
  float r1,r2,a0,a2,d,wr;
  float rot;
  
  Tree(){
    r1= 0.9;
    r2= 0.6;
    a0= radians(45);
    a2 = radians(45);
    d = radians(137.5);
    wr =0.707;
    word = new Word();
    word.add(new A(10,10));
    defineRules();
  }
  
  void defineRules(){
    
    // A(l,w) : *→ !(w)F(l)[&(a0)B(l*r2,w*wr)]/(d)A(l*r1,w*wr)
    rules.put("A", new ParametricRule() {
        public ArrayList<Module> rule(Module m) { 
            float w = m.getP(1);
            float l = m.getP(0);
            ArrayList<Module> ret = new  ArrayList<Module>();
            ret.add(new Exclamation(w));
            ret.add(new F(l));
            ret.add(new LBrack());
            ret.add(new And(a0));
            ret.add(new B(l*r2, w*wr));
            ret.add(new RBrack());
            ret.add(new Slash(d));
            ret.add(new A(l*r1, w*wr));
           return ret;
        };
    });
    
    //B(l,w) : *→!(w)F(l)[-(a2)$C(l*r2,w*wr)]C(l*r1,w*wr)
    rules.put("B", new ParametricRule() {
        public ArrayList<Module> rule(Module m) { 
            float w = m.getP(1);
            float l = m.getP(0);
            ArrayList<Module> ret = new  ArrayList<Module>();
            ret.add(new Exclamation(w));
            ret.add(new F(l));
            ret.add(new LBrack());
            ret.add(new Minus(a2));
            ret.add(new Dollar());
            ret.add(new C(l*r2, w*wr));
            ret.add(new RBrack());
            ret.add(new C(l*r1, w*wr));
           return ret;
        };
    });
    
    //C(l,w) : *→!(w)F(l)[+(a2)$B(l*r2,w*wr)]B(l*r1,w*wr)
    rules.put("C", new ParametricRule() {
        public ArrayList<Module> rule(Module m) { 
            float w = m.getP(1);
            float l = m.getP(0);
            ArrayList<Module> ret = new  ArrayList<Module>();
            ret.add(new Exclamation(w));
            ret.add(new F(l));
            ret.add(new LBrack());
            ret.add(new Plus(a2));
            ret.add(new Dollar());
            ret.add(new B(l*r2, w*wr));
            ret.add(new RBrack());
            ret.add(new B(l*r1, w*wr));
           return ret;
        }
    });
  }
}
