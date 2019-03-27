
class F extends Module{
  F( float d){
    super("F");
    addParam("distance", d);
  }

  void drawFunction(){
    turtle.forward(getP("distance"));
  }
  String repr(){
     return "";
    //return "F" +"("+getP("distance")+")";
  }
}

class Plus extends Module{
  Plus( float a){
    super("+");
    addParam("angle", a);
  }

  void drawFunction(){
    //rotateZ(parameters[0]);
    turtle.Ru(getP("angle"));
  }
}

class Minus extends Module{
  Minus( float a){
    super("-");
    addParam("angle", a);
  }

  void drawFunction(){
    turtle.Ru(-getP("angle"));
  }
}

class Hat extends Module{
  Hat( float a){
    super("^");
    addParam("angle", a);
  }

  void drawFunction(){
    turtle.Rl(-getP("angle"));
  }
}
class And extends Module{
  And( float a){
    super("&" );
    addParam("angle", a);
  }
  
  void drawFunction(){
    turtle.Rl(getP("angle"));
  }
}

class Slash extends Module{
  Slash( float a){
    super("/" );
    addParam("angle", a);
  }

  void drawFunction(){
    turtle.Rh(-getP("angle"));
  }
}
class BSlash extends Module{
  BSlash( float a){
    super("\\");
    addParam("angle", a);
  }

  void drawFunction(){
    turtle.Rh(getP("angle"));
  }
}
class Turn180 extends Module{
  Turn180( float a){
    super("|");
  }

  void drawFunction(){
    turtle.Ru(radians(180));
  }
}

class Move extends Module{
  Move(float d){
    super("f");
    addParam("distance", d);
  }

  void drawFunction(){
    translate(0,getP("distance"));
  }
}

class LBrack extends Module{
  LBrack(){
    super("[");
  }

  void drawFunction(){
    turtle.push();
  }
  
}
class RBrack extends Module{
  RBrack(){
    super("]");
  }

  void drawFunction(){
    turtle.pop();
  }
}

class Green extends Module{
  Green(){
    super("Green");
  }

  void drawFunction(){
    stroke(0,200,0); 
  }
  void drawFunction(PShape p){
    p.stroke(0,200,0); 
    //p.fill(0,200,0);
  }
}

class Orange extends Module{
  Orange(){
    super("Orange");
  }

  void drawFunction(){
    stroke(150,150,0); 
  }
  void drawFunction(PShape p){
    p.stroke(150,150,0);  
        //p.fill(150,150,0);

  }
  
}
class Purple extends Module{
  Purple(){
    super("Purple");
  }

  void drawFunction(){
    stroke(255,0,200); 
  }
    void drawFunction(PShape p){
    p.stroke(255,0,200); 
    //p.fill(255,0,200);
  }
}
class White extends Module{
  White(){
    super("White");
  }

  void drawFunction(){
    stroke(255,255,255); 
  }
  
  void drawFunction(PShape p){
    p. stroke(255,255,255); 
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
  Exclamation(float w){
    super("!");
    addParam("width", w);
  }

  void drawFunction(){
    strokeWeight(this.getP("width"));
  }
  
  String repr(){
    return "!" + "(" +this.getP("width") +")";
  }
}

class Cut extends Module{
  Cut(){
    super("%");
  }
}

class EndCut extends Module{
  EndCut(){
    super("-%");
  }
}

class Segment extends Module{
  UUID id;
  Segment(){
    super("SEG");
    id = UUID.randomUUID();
  }
}

class SegmentMerge extends Module{
  SegmentMerge(){
    super("MERGE");
  }
}
class Rradial extends Module{
     Rradial( float angle){
      super("Radial");
       addParam("angle", angle);    
    } 
    String repr(){
      return "";
    }
    
    void drawFunction(){
      getTurtle().Rh(getP("angle"));
    }
  }
  
  class Raxial extends Module{
    Raxial( float angle){
      super("Axial");
      addParam("angle", angle);
    } 
    String repr(){
      return "";
    }
    
    void drawFunction(){
      turtle.Rl(getP("angle"));
    }
  }
