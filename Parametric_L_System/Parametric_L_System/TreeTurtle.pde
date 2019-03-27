import java.util.ArrayDeque;

void translate(PVector p){
  translate(p.x,p.y,p.z);
}

class Wind{
  float amount = 0; 
  float fluctuation = 1000; 

  void update(float strength){
    amount = (noise(frameCount/1000.) -0.5)*strength;
    println("Wind amoun"+ amount);
  }
  
}

Wind wind= new Wind();

class SegmentShape{
  PVector startPos;
  PVector endPos;
  PVector H, L,U;
  PVector Hend, Lend,Uend;

  PShape shape;
  
  SegmentShape(){
    shape = createShape();

  }
  
  void generateShape(ArrayList<Module> modules){
    
    startPos = turtle.position.copy();
    
    H = turtle.H.copy();
    L = turtle.L.copy();
    U = turtle.U.copy();
    shape = createShape();
    
    shape.beginShape(LINES);
    shape.stroke(0);
    for (Module m: modules){
      if (m.letter=="F"){
        addVertex(turtle.position);
        m.drawFunction(shape);
        addVertex(turtle.position);
      }
      else{
        m.drawFunction(shape);
      }
    }
    shape.endShape(CLOSE);
    Hend = turtle.H.copy();
    Lend = turtle.L.copy();
    Uend = turtle.U.copy();
    endPos = turtle.position.copy();

  }
  
  void addVertex(PVector p){
     shape.vertex(p.x,p.y, p.z);
  }
  
  void drawShape(){
   //PShape ps = createShape();
   //    ps.beginShape(LINES);
   // int max_y = -20;

   //for (int i = 0; i < shape.getVertexCount(); i++) {
   // PVector v = shape.getVertex(i);
   // v.x += wind.amount*map(v.y,0, max_y, 0,10);
   // //v.y += random(-1,1);
   // ps.vertex(v.x, v.y, v.z);
    
   //}
   //ps.endShape(CLOSE);

    
   shape(shape);
  }
  
  void goToEnd(){
    turtle.L = Lend.copy();
    turtle.H = Hend.copy();
    turtle.U = Uend.copy();
    turtle.position = endPos.copy();
  }
  
}

//From p.19
class ShapeTurtle{
  PVector H, L,U;
  PVector V, T;  
  PVector position;
  int depth;

  float e;
  boolean TROPISM =false;
  ArrayDeque<PVector> hstack;
  ArrayDeque<PVector> lstack;
  ArrayDeque<PVector> ustack;
  ArrayDeque<PVector> pstack;
  HashMap<UUID, SegmentShape> shapes;

  ShapeTurtle(){
    U = new PVector(0, -1,0);
    L = new PVector(-1, 0,0);
    H = new PVector(0,0,1);
    V = new PVector(0,0,-1);
    T = new PVector(0,0,-1);
    position = new PVector(0,0,0);

    e = 0.0;
    hstack = new ArrayDeque<PVector>();
    lstack = new ArrayDeque<PVector>();
    ustack = new ArrayDeque<PVector>();
    pstack = new ArrayDeque<PVector>();
    shapes = new HashMap<UUID,SegmentShape>(); 
  }
 
    
  void updateSegment(UUID id, ArrayList<Module> segment){
    if (!shapes.containsKey(id)){
      shapes.put(id, new SegmentShape());
    }
    shapes.get(id).generateShape(segment);
  }
  
 void removeSegment(UUID id){
    shapes.remove(id);
  }
  
  void goTo(UUID id){
    shapes.get(id).goToEnd();
  }
  
  void drawSegments(ArrayList<UUID> segmentIds){
    if (segmentIds == null){
      return;
    }
    for (UUID id : segmentIds){
      shapes.get(id).drawShape();
    } 
  }
  
  void moveTo(float x, float y){
    turtle.position.x = x;
    turtle.position.y = y;
  }
  
  void reset(){
    U = new PVector(0, 0,1);
    L = new PVector(-1, 0,0);
    H = new PVector(0,-1,0);
    V = new PVector(0,1,0);
    position = new PVector(0,0,0);
    depth = 0;
  }
  
  void Ru(float alpha){
    Raxis(U, alpha);
  }
    
  void Rl(float alpha){
    Raxis(L, alpha);
  }
  
  void Rh(float alpha){
    Raxis(H, alpha);
  }
  
  void reorientHorizontal(){
    L = V.cross(H).div(V.cross(H).mag());
    U = H.cross(L);
  }
    
  void normalizeDirections(){
    L = L.normalize();
    U = U.normalize();
    H = H.normalize();

  }
  
  void forward(float l){
    if (TROPISM){
      applyTropism();
    }
    PVector d= new PVector(H.x,H.y,H.z);
    d.mult(l);
    //line(position.x,position.y,position.z,position.x+d.x,position.y+ d.y,position.z+d.z);
    position = position.add(d);
  }
    
  void push(){
    //pushMatrix();
    hstack.push(new PVector(H.x,H.y, H.z));    
    lstack.push(new PVector(L.x,L.y, L.z));
    ustack.push(new PVector(U.x,U.y, U.z));
    pstack.push(new PVector(position.x,position.y, position.z));
    depth +=1;
  }
  
  void pop(){
    H = hstack.pop();
    L = lstack.pop();
    U = ustack.pop();
    position = pstack.pop();
    depth -=1;
  }
  
  
  void setTropism(PVector t, float e){
    TROPISM = true;
    this.T = t;
    this.e = e;
  }
  
  
  void  applyTropism(){
    PVector axis = new PVector();
    H.cross(T,axis);
    if (axis.mag() ==0){
      PVector newvec = new PVector(T.x+0.001,T.y, T.z);
       H.cross(newvec,axis);
    }
    float alpha = radians(e *axis.mag());
    float a2 = PVector.angleBetween(T,H);
    float angle = min(a2,alpha);
    //drawDebugLine(H, color(0,0,255));
    //drawDebugLine(T);
    Raxis(axis.normalize(),angle);
    //drawDebugLine(axis, color(0,255,0));

  }
  
  //Rotate alpha degrees around axis A
  //https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle
  void Raxis(PVector A, float alpha){
    PVector r1,r2,r3;
                     
    r1 = new PVector(cos(alpha) + pow(A.x,2)*(1-cos(alpha)),
                     A.x*A.y*(1-cos(alpha)) -A.z*sin(alpha), 
                     A.x*A.z*(1-cos(alpha)) +A.y*sin(alpha));
                     
    r2 = new PVector(A.x*A.y*(1-cos(alpha)) +A.z*sin(alpha), 
                     cos(alpha) + pow(A.y,2)*(1-cos(alpha)),
                     A.y*A.z*(1-cos(alpha)) -A.x*sin(alpha));
                     
    r3 = new PVector(A.x*A.z*(1-cos(alpha)) -A.y*sin(alpha), 
                     A.y*A.z*(1-cos(alpha)) +A.x*sin(alpha),
                     cos(alpha)+ pow(A.z,2)*(1-cos(alpha)));

    H = new PVector(H.dot(r1),H.dot(r2), H.dot(r3)); 
    L = new PVector(L.dot(r1),L.dot(r2), L.dot(r3)); 
    U = new PVector(U.dot(r1),U.dot(r2), U.dot(r3)); 
    normalizeDirections();
  }
}
