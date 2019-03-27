import java.util.ArrayDeque;

//From p.19
class Turtle{
  PVector H, L,U;
  PVector V, T;
  float e;
  boolean TROPISM =false;
  ArrayDeque<PVector> hstack;
  ArrayDeque<PVector> lstack;
  ArrayDeque<PVector> ustack;


  Turtle(){
    U = new PVector(0, -1,0);
    L = new PVector(-1, 0,0);
    H = new PVector(0,0,1);
    V = new PVector(0,0,-1);
    T = new PVector(0,0,-1);
    e = 0.0;
    hstack = new ArrayDeque<PVector>();
    lstack = new ArrayDeque<PVector>();
    ustack = new ArrayDeque<PVector>();
  }
  
  void reset(){
    U = new PVector(0, 0,1);
    L = new PVector(-1, 0,0);
    H = new PVector(0,-1,0);
    V = new PVector(0,1,0);
  }
  
  void Ru(float alpha){  
    PVector c1 = new PVector(cos(alpha),-sin(alpha),0); 
    PVector c2 = new PVector(sin(alpha), cos(alpha), 0);
    PVector c3 = new PVector(0,0,1);
    
    PVector tr1= new PVector(H.x, L.x, U.x);
    PVector tr2= new PVector(H.y, L.y, U.y);
    PVector tr3= new PVector(H.z, L.z, U.z);

    H = new PVector(tr1.dot(c1),tr2.dot(c1), tr3.dot(c1)); 
    L = new PVector(tr1.dot(c2),tr2.dot(c2), tr3.dot(c2)); 
    U = new PVector(tr1.dot(c3),tr2.dot(c3), tr3.dot(c3)); 
  }
    
  void Rl(float alpha){
    //PVector r1 = new PVector(cos(alpha),0, -sin(alpha));  //<>// //<>//
    //PVector r2 = new PVector(0,1,0);
    //PVector r3 = new PVector(sin(alpha),0,cos(alpha));
    
    PVector c1 = new PVector(cos(alpha),0, sin(alpha)); 
    PVector c2 = new PVector(0, 1, 0);
    PVector c3 = new PVector(-sin(alpha), 0, cos(alpha));
    
    PVector tr1= new PVector(H.x, L.x, U.x);
    PVector tr2= new PVector(H.y, L.y, U.y);
    PVector tr3= new PVector(H.z, L.z, U.z);

    H = new PVector(tr1.dot(c1),tr2.dot(c1), tr3.dot(c1)); 
    L = new PVector(tr1.dot(c2),tr2.dot(c2), tr3.dot(c2)); 
    U = new PVector(tr1.dot(c3),tr2.dot(c3), tr3.dot(c3)); 
  }
  
  void Rh(float alpha){
    //PVector r1 = new PVector(1,0,0);  //<>// //<>//
    //PVector r2 = new PVector(0,cos(alpha),-sin(alpha));
    //PVector r3 = new PVector(0, sin(alpha),cos(alpha));
    
    PVector c1 = new PVector(1,0, 0); 
    PVector c2 = new PVector(0, cos(alpha), sin(alpha));
    PVector c3 = new PVector(0, -sin(alpha), cos(alpha));
    
    PVector tr1= new PVector(H.x, L.x, U.x);
    PVector tr2= new PVector(H.y, L.y, U.y);
    PVector tr3= new PVector(H.z, L.z, U.z);

    H = new PVector(tr1.dot(c1),tr2.dot(c1), tr3.dot(c1)); 
    L = new PVector(tr1.dot(c2),tr2.dot(c2), tr3.dot(c2)); 
    U = new PVector(tr1.dot(c3),tr2.dot(c3), tr3.dot(c3)); 
  }
  
  void reorientHorizontal(){
    L = V.cross(H).div(V.cross(H).mag());
    U = H.cross(L);
  }
  
  void forward(float l){
    if (TROPISM){
      applyTropism();
    }
    PVector n = new PVector(random(0,0.3),random(0,0.3),random(0,0.3));
    PVector d= new PVector(H.x,H.y,H.z);
    d.mult(l);
    //ellipse(0,0, 1,1);
    line(0,0,0,d.x, d.y,d.z);
    translate(d.x, d.y,d.z);
    //ellipse(0,0, 1,1);

  }
    
  void push(){
    hstack.push(H);
    lstack.push(L);
    ustack.push(U);

  }
  
  void pop(){
    H = hstack.pop();
    L = lstack.pop();
    U = ustack.pop();
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
    Raxis2(axis.normalize(),angle);
    //drawDebugLine(axis, color(0,255,0));

  }
  
  //Rotate alpha degrees around axis A
  //https://en.wikipedia.org/wiki/Rotation_matrix#Rotation_matrix_from_axis_and_angle
  void Raxis2(PVector A, float alpha){
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
  }
  
 

}
