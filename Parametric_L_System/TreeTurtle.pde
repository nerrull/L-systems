import java.util.ArrayDeque; //<>// //<>//

void translate(PVector p) {
  translate(p.x, p.y, p.z);
}

void addVertex(PShape s, PVector p) {
    s.vertex(p.x, p.y, p.z);
}

void replaceVertex(PShape s, PVector p, int index) {
    s.setVertex(index, p.x, p.y, p.z);
}

//From p.19
class ShapeTurtle {
  PVector H, L, U;
  PVector V, T;  
  PVector position;
  int depth;
  PGraphics canvas;
  float e;
  boolean TROPISM =false;
  ArrayDeque<PVector> hstack;
  ArrayDeque<PVector> lstack;
  ArrayDeque<PVector> ustack;
  ArrayDeque<PVector> pstack;
  TurtleState neutralState;

  ShapeTurtle() {
    U = new PVector(0, -1, 0);
    L = new PVector(-1, 0, 0);
    H = new PVector(0, 0, 1);
    V = new PVector(0, 0, -1);
    T = new PVector(0, 0, -1);
    position = new PVector(0, 0, 0);
    
    neutralState = new TurtleState(this);
    e = 0.0;
    hstack = new ArrayDeque<PVector>();
    lstack = new ArrayDeque<PVector>();
    ustack = new ArrayDeque<PVector>();
    pstack = new ArrayDeque<PVector>();
    canvas =null;
  }

  void setCanvas(PGraphics c) {
    this.canvas =c;
  }


  void moveTo(float x, float y) {
    turtle.position.x = x;
    turtle.position.y = y;
  }
  
  void moveTo(float x, float y, float z) {
    turtle.position.x = x;
    turtle.position.y = y;
    turtle.position.z = z;
  }
  
  void applyState(TurtleState s){
    H = s.H.copy();
    L = s.L.copy();
    U = s.U.copy();
    position = s.pos.copy();
  }
  
  void applyStateOrientation(TurtleState s){
    H = s.H.copy();
    L = s.L.copy();
    U = s.U.copy();
  }
  void reset() {
    U = new PVector(0, 0, 1);
    L = new PVector(-1, 0, 0);
    H = new PVector(0, -1, 0);
    V = new PVector(0, 1, 0);
    position = new PVector(0, 0, 0);
    depth = 0;
  }

  void Ru(float alpha) {
    Raxis(U, alpha);
  }

  void Rl(float alpha) {
    Raxis(L, alpha);
  }

  void Rh(float alpha) {
    Raxis(H, alpha);
  }

  void reorientHorizontal() {
    L = V.cross(H).div(V.cross(H).mag());
    U = H.cross(L);
  }

  void normalizeDirections() {
    L = L.normalize();
    U = U.normalize();
    H = H.normalize();
  }

  void forward(float l) {
    if (TROPISM) {
      applyTropism();
    }
    PVector d= new PVector(H.x, H.y, H.z);
    d.mult(l);
    position = position.add(d);
  }

  void move(float l) {
    PVector d= new PVector(H.x, H.y, H.z);
    d.mult(l);
    position = position.add(d);
  }

  void push() {
    //pushMatrix();
    hstack.push(new PVector(H.x, H.y, H.z));    
    lstack.push(new PVector(L.x, L.y, L.z));
    ustack.push(new PVector(U.x, U.y, U.z));
    pstack.push(new PVector(position.x, position.y, position.z));
    depth +=1;
    //println("Depth " + depth);
  }

  void pop() {
    //println("Depth " + depth);

    H = hstack.pop();
    L = lstack.pop();
    U = ustack.pop();
    position = pstack.pop();
    depth -=1;
  }


  void setTropism(PVector t, float e) {
    TROPISM = true;
    this.T = t;
    this.e = e;
  }

  void  applyTropism() {
    PVector axis = new PVector();
    H.cross(T, axis);
    if (axis.mag() ==0) {
      PVector newvec = new PVector(T.x+0.001, T.y, T.z);
      H.cross(newvec, axis);
    }
    float alpha = radians(e *axis.mag());
    float a2 = PVector.angleBetween(T, H);
    float angle = min(a2, alpha);
    //drawDebugLine(H, color(0,0,255));
    //drawDebugLine(T);
    Raxis(axis.normalize(), angle);
    //drawDebugLine(axis, color(0,255,0));
  }

  //Rotate alpha degrees around axis A
  //https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle
  void Raxis(PVector A, float alpha) {
    PVector r1, r2, r3;

    r1 = new PVector(cos(alpha) + pow(A.x, 2)*(1-cos(alpha)), 
      A.x*A.y*(1-cos(alpha)) -A.z*sin(alpha), 
      A.x*A.z*(1-cos(alpha)) +A.y*sin(alpha));

    r2 = new PVector(A.x*A.y*(1-cos(alpha)) +A.z*sin(alpha), 
      cos(alpha) + pow(A.y, 2)*(1-cos(alpha)), 
      A.y*A.z*(1-cos(alpha)) -A.x*sin(alpha));

    r3 = new PVector(A.x*A.z*(1-cos(alpha)) -A.y*sin(alpha), 
      A.y*A.z*(1-cos(alpha)) +A.x*sin(alpha), 
      cos(alpha)+ pow(A.z, 2)*(1-cos(alpha)));

    H = new PVector(H.dot(r1), H.dot(r2), H.dot(r3)); 
    L = new PVector(L.dot(r1), L.dot(r2), L.dot(r3)); 
    U = new PVector(U.dot(r1), U.dot(r2), U.dot(r3)); 
    normalizeDirections();
  }
}


class TurtleState{
  PVector pos;
  PVector H, L, U;
  int shapeType;

  TurtleState(ShapeTurtle turtle){
    H = turtle.H.copy();
    L = turtle.L.copy();
    U = turtle.U.copy();
    pos = turtle.position.copy();
  }
  
  TurtleState(TurtleState ts){
    H = ts.H.copy();
    L = ts.L.copy();
    U = ts.U.copy();
    pos = ts.pos.copy();
  }
  
  void update(ShapeTurtle turtle){
    H = turtle.H.copy();
    L = turtle.L.copy();
    U = turtle.U.copy();
    pos = turtle.position.copy();
  }
  
  TurtleState add(TurtleState ts){
    this.pos = this.pos.add(ts.pos);
    return new TurtleState(this);
  }

  void applyToCanvas(PGraphics c){

  }
}


class LeafShape{
  PShape shape;
  TurtleState state;

  LeafShape(TurtleState ts, PShape s){
    this.shape =s;
    this.state= ts;

  }

  void draw(PGraphics c){
    pushMatrix();
    popMatrix();
  }

}

int LINE_SHAPE = 0;
int SOLID_SHAPE = 1;
class WordShape {
  PShape shape;
  TurtleState state;
  int n_draws;
  int shapeType;
  color fillColor;
  boolean shapeBegun;
  WordShape() {
    shape = createShape();
    n_draws =0;
    shapeType = LINE_SHAPE;
    fillColor = color(0);
  }
  
  void setTurtleState(TurtleState ts){
    this.state = ts;
  }
  
  void printword(ArrayList<Module> modules) {
    println();
    for (Module m : modules) {
      print(m.repr());
    }
  }
  
  void generateShape(Iterator<Module> it,  HashMap<UUID, NodeWord> children, boolean reset){
    //n_draws = 5;
    //generateShape( it, children);
  }
  
  void beginShape(){
    if (this.shapeType ==LINE_SHAPE){
      shape.beginShape();
      shape.noFill();
      shape.stroke(0);
      shape.strokeWeight(2);
    }
    else{
      shape.beginShape();
      shape.fill(fillColor);
      shape.stroke(0);
      shape.strokeWeight(2);
    }
    shapeBegun =true;
  }
  
  void endShape(){
     if (this.shapeType ==LINE_SHAPE){
       shape.endShape();
     }
     else {
       shape.endShape(CLOSE);
     }
  }
  
  void generateShape(Iterator<Module> it,  HashMap<UUID, NodeWord> children) {
    shapeBegun =false;
    turtle.reset();
    turtle.applyStateOrientation(this.state);
    n_draws++;
    
    //Dunno why but need to recreate the damn shape when we make filled shapes?
    //Animations on leaves don't work if we don't createShape
    //if(n_draws >5){
    //  shape = createShape();
    //  n_draws =0;
    //}
    
    int oldShapeCount =shape.getVertexCount();

    int index = 0;
    if (oldShapeCount ==0){
       beginShape();
    }
    Module m;
    while(it.hasNext()) {
      m= it.next();
      //LeafPointer
      //if (m.letter == "LP"){
      //  LeafPointer l  = (LeafPointer )m;
      //  this.shape.addChild(leafManager.get);        
      //  NodeWord child = children.get(i.id);
      //  TurtleState ts = new TurtleState(turtle);
      //  child.updateTurtleState(ts);
      //}

      if (m.letter == "ID"){
        ID i  = (ID )m;        
        NodeWord child = children.get(i.id);
        TurtleState ts = new TurtleState(turtle);
        child.updateTurtleState(ts);
      }
      if (index  <oldShapeCount){
        try{
          index +=m.drawFunction(shape, index);
        }
        catch (Exception e){
          println("why");
        }
        if (index >=oldShapeCount){
          this.beginShape();
        }
      }
      else {
        try{m.drawFunction(shape);}
        catch (Exception e){
          println("why");
        }
        index++;
      }
    }
    if (shapeBegun){
      this.endShape();
    }
  }

  void drawShape(PGraphics c) {   
    c.shape(shape);
  }
  
  void translate(PGraphics c){
    c.translate(this.state.pos.x,this.state.pos.y,this.state.pos.z);
  }
  
}
