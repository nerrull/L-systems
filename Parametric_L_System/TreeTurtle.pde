import java.util.ArrayDeque; //<>//

void translate(PVector p) {
  translate(p.x, p.y, p.z);
}

class Wind {
  float amount = 0; 
  float fluctuation = 1000; 

  void update(float strength) {
    amount = (noise(frameCount/1000.) -0.5)*strength;
    //println("Wind amoun"+ amount);
  }
}

Wind wind= new Wind();
int sign(float v){
  if (v>=0) return 1;
  else return -1;
}

void addVertex(PShape s, PVector p) {
    s.vertex(p.x, p.y, p.z);
}
class SegmentShape {
  PVector startPos;
  PVector endPos;
  PVector H, L, U;
  PVector Hend, Lend, Uend;

  PShape shape;

  ArrayDeque<PVector> hstack;
  ArrayDeque<PVector> lstack;
  ArrayDeque<PVector> ustack;
  ArrayDeque<PVector> pstack;
  ShapeTurtle t;
  SegmentShape() {
    shape = createShape();
  }
  void printword(ArrayList<Module> modules) {
    println();
    for (Module m : modules) {
      print(m.repr());
    }
  }

  void generateShape(ArrayList<Module> modules) {

    shape = createShape();

    shape.beginShape(LINES);
    shape.stroke(0);
    shape.strokeWeight(2);

    int index = 0;
    for (Module m : modules) {
      index++;
      if (m.letter=="]") {
        if (turtle.depth ==0) {
          println("Failed at module : "+index);
          printword(modules);
          print("WAAAT");
        }
        turtle.pop();
      } else {
        m.drawFunction(shape);
      }
    }
    shape.endShape(CLOSE);
    Hend = turtle.H.copy();
    Lend = turtle.L.copy();
    Uend = turtle.U.copy();
    endPos = turtle.position.copy();
    hstack = new ArrayDeque<PVector> (turtle.hstack);
    lstack = new ArrayDeque<PVector> (turtle.lstack);
    ustack = new ArrayDeque<PVector> (turtle.ustack);
    pstack = new ArrayDeque<PVector> (turtle.pstack);
  }

  void addVertex(PVector p) {
    shape.vertex(p.x, p.y, p.z);
  }

  void drawShape() {    
    shape(shape);
  }

  void drawShape(PGraphics c) {    
    c.shape(shape);
  }

  void goToEnd() {
    turtle.L = Lend.copy();
    turtle.H = Hend.copy();
    turtle.U = Uend.copy();
    turtle.position = endPos.copy();
    turtle.hstack = new ArrayDeque<PVector> (hstack);    
    turtle.lstack = new ArrayDeque<PVector> (lstack);
    turtle.ustack = new ArrayDeque<PVector> (ustack);
    turtle.pstack = new ArrayDeque<PVector> (pstack);
  }
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
  HashMap<UUID, SegmentShape> shapes;

  ShapeTurtle() {
    U = new PVector(0, -1, 0);
    L = new PVector(-1, 0, 0);
    H = new PVector(0, 0, 1);
    V = new PVector(0, 0, -1);
    T = new PVector(0, 0, -1);
    position = new PVector(0, 0, 0);

    e = 0.0;
    hstack = new ArrayDeque<PVector>();
    lstack = new ArrayDeque<PVector>();
    ustack = new ArrayDeque<PVector>();
    pstack = new ArrayDeque<PVector>();
    shapes = new HashMap<UUID, SegmentShape>(); 
    canvas =null;
  }

  void setCanvas(PGraphics c) {
    this.canvas =c;
  }

  void updateSegment(UUID id, ArrayList<Module> segment) {
    if (!shapes.containsKey(id)) {
      shapes.put(id, new SegmentShape());
    }
    shapes.get(id).generateShape(segment);
  }


  void removeSegment(UUID id) {
    shapes.remove(id);
  }

  void goTo(UUID id) {
    shapes.get(id).goToEnd();
  }

  void drawSegments(ArrayList<UUID> segmentIds) {
    if (segmentIds == null) {
      return;
    }

    if (this.canvas!=null) {
      canvas.pushMatrix();
      canvas.translate(turtle.position.x, turtle.position.y, turtle.position.z);
    }
    for (UUID id : segmentIds) {
      if (this.canvas!=null) {
        shapes.get(id).drawShape(this.canvas);
      } else {
        shapes.get(id).drawShape();
      }
    } 
    if (this.canvas!=null) {
      canvas.popMatrix();
    }
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
