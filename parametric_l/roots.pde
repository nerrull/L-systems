/*From
Leitner, Daniel , Klepsch, Sabine , Knieß, Astrid and Schnepf, Andrea(2010) 'The algorithmic beauty of
plant roots - an L-System model for dynamic root growth simulation', Mathematical and Computer Modelling of
Dynamical Systems, 16: 6, 575 — 587
*/


class RootModule extends Module{
    HashMap<String, Float> initial_params;
    String next;
    RootModule(String name, float [] params,String n  ){
      super(name, params);
      this.next= n;
      initial_params = new HashMap<String, Float> ();
    }
    
    float getI(String name){
      return initial_params.get(name);
    }
    
    void addInitialParam(String name, float value){
      initial_params.put(name, value);
    }
}


class Root extends ParametricLSystem{
  //Root parameters
  float maxLength, growthSpeed, ls; 
  float delta_x,delta_t;
  float [] lb,la,ln, axial_SD, offShootAngles;
  int maxOrder, nBranches;
  Root(){
    this.maxLength  =10;
    this.growthSpeed = 1;
    this.delta_x = 0.5;
    this.delta_t = 1.;
    this.maxOrder = 3;
    this.nBranches =5;
    
    //Length of basal zone
    this.lb = new float[]{10,3,3};
   //Length of interbranch zone
    this.ln = new float[]{20,5,5};
        //Length of apical zone

    this.la = new float[]{10,5,5};
    this.axial_SD = new float[]{radians(9),radians(18),radians(18)};
    this.offShootAngles = new float[]{radians(70),radians(70),radians(70)};

    defineRules();
    word = new Word();

    RootModule m = new S(0,0, lb[0],0, "branching_zone");
    println(m.getI("order"));
    word.add(m);
  }
  
  void setParams(float ml, float gs, float delta_x, float delta_t, float offshootAngle ){
    this.delta_x = delta_x;
    this.delta_t = delta_t;
    this.maxLength = ml;
    this.growthSpeed = gs;
    //Length of apical zone

  }
  
  //Negative exponential root growth
  //Maxlength and growthspeed are global parameters of the root
  float rootGrowth(float time, float maxLength){
    float len = maxLength*(1-exp(-growthSpeed/maxLength*time));
    return len;
  }
  
  /* Tip deflection functions
  A simple approach to model the effect of soil particles on the root growth
  is to modify the growth direction of the root tip randomly
  */
  float getRadial(){
    return random(-PI, PI);
  }
  
  //1/dx is segments/cm
  //Sigma controls how much direction changes per cm of root growth
  float getAxial(float dx, float sigma){
    float variance = sqrt(dx)*sigma;
    return gaussian(0, variance); 
  }
  
  // Sample N radial and axial rotations, 
  //select the one that is closest to the down vector
  float gravitropism(){
    return 0;
  }
  
  // Sample N radial and axial rotations, 
  //select the one that is closest to the horizontal vector
  float plagiotropism(){
    return 0;
  }

  
  ArrayList<Module> getNextSection(String name, int order){

    ArrayList<Module> ret = new ArrayList<Module>();
    if (order >=(maxOrder-1)){
         return ret;
    }
    if (name =="branch"){
      int o = (int) order +1;
      ret.add(new LBrack());
      ret.add(new Roffshoot(this.offShootAngles[ o]));
      ret.add(new R(o));
      ret.add(new S(0,0,lb[o],o,"branching_zone"));
      ret.add(new RBrack());      
    }
    else if (name =="branching_zone"){
       ret.add(new B(0,order));
    }
    else if (name =="tip"){
      ret.add(new S(0,0,la[order],order, "" ));
    }
    //Continue branching zone
    else if (name.indexOf("B")>-1){
      int c = Integer.parseInt((name.substring(1)));
      ret.add(new B(c,order));
    }
    else if (name ==""){
      println ("donezo");
    }
    return ret;
  }
  
  //Root rules
  ParametricRule DelayRule = new ParametricRule() {
    public ArrayList<Module> rule(Module m) { 
      ArrayList<Module> ret = new  ArrayList<Module>();
      RootModule rm = (RootModule) m;
      float t = m.getP(0);
      float order = rm.getI("order");
      float t_end = rm.getI("t_end");
      if (t+delta_t>= t_end){
        ret.addAll(getNextSection(rm.next, (int)order));
      }
      else{
        ret.add(new D(t+delta_t, t_end, order, rm.next));
      }
      return ret;
    };
  };
  
  //A := λ(t0) + l + delta_x ≤ λ(t0 + t + t),
  boolean a_condition(float l, float maxLength, float t, float delta_x, float delta_t){
    return (l + delta_x<= rootGrowth(t+delta_t, maxLength));
  }
  
  ParametricRule SegmentRule = new ParametricRule() {
    public ArrayList<Module> rule(Module m) { 
      ArrayList<Module> ret = new  ArrayList<Module>();
      RootModule rm = (RootModule) m;

      float t = m.getP(0);
      float l = m.getP(1);
      float order =  rm.getI("order");
      float maxLen = rm.getI("maxLen");

      boolean a = a_condition( l, maxLen, t, delta_x, delta_t);
      float c1 = l+delta_x;
      float c2 = rootGrowth(t+delta_t, maxLen);
      //println(" Condition" +c1+ "<=" +c2);
      //A & (l+delta_x < ls): R F(delta_x) S(t,l+delta_x)
      if (a &&(l+delta_x < maxLen)){
        ret.add(new R(order));
        ret.add(new F(delta_x));
        ret.add(new S(t, l+delta_x, maxLen, order, rm.next));
      }
      //A & (l+delta_x ≥ ls): R F(ls−l) Nst+delata_t−(tend−t0)
      else if (a && l+delta_x >= maxLen){
        ret.add(new R(order));
        ret.add(new F(maxLen-l));
        ret.addAll(getNextSection(rm.next, (int)order));
      }
      else{
        ret.add(new S(t+delta_t, l, maxLen, order, rm.next));
      }
      return ret;
    };
  };
  
  ParametricRule BranchingRule = new ParametricRule() {
    public ArrayList<Module> rule(Module m) { 
      ArrayList<Module> ret = new  ArrayList<Module>();
      RootModule rm = (RootModule) m;

      int c =(int) m.getP(0);
      int order =(int) rm.getI("order");
      float delay =ln[order]/delta_t *10;
      //c<n: D(0; dc, Nb )S(0, 0; t0,c, tend,c, B(c+1), λ, delta_x)
      if (c<nBranches){
        ret.add(new D(0, delay, order, "branch"));
        ret.add(new S(0,0,lb[order],order, "B"+str(c+1)));
      }
      else {
        ret.add(new D(0, delay,order,  "branch"));
        ret.add(new S(0,0,lb[order],order, "tip"));
      }
      return ret;
    };
  };
  
  ParametricRule RotationRule = new ParametricRule() {
    //l+delta_x < λ(t+delta_t) : R F G(t,l+delta_x)
    public ArrayList<Module> rule(Module m) { 
      RootModule rm = (RootModule) m;

      int order = (int) rm.getI("order");
      ArrayList<Module> ret = new  ArrayList<Module>();
      ret.add(new Raxial(getAxial(1,axial_SD[order])));
      ret.add(new Rradial(getRadial()));
      return ret;
    };
  };

 
  
  void defineRules(){
    rules.put("S", SegmentRule);
    rules.put("D", DelayRule);
    rules.put("R", RotationRule);
    rules.put("B", BranchingRule);

  }
  
    
  //// Root modules
  class D extends RootModule{
    D(float t, float t_end, float order, String next){
      super("D", new float[] {t}, next);
      addInitialParam("t_end", t_end);
      addInitialParam("order", order);
    }
    void drawFunction(){
      pushStyle();
      fill(255,0,0);
      ellipse(0,0,2,2);
      popStyle();
    }
  }
  
  class S extends RootModule{
    S( float t, float l, float maxLen, float order, String next ){
      super("S", new float[] {t,l}, next);
      addInitialParam("order", order);
      addInitialParam("maxLen", maxLen);
    }
  }
  
  class B extends RootModule{
    B( float c, float order){
      super("B", new float[] {c}, "");
      addInitialParam("order", order);
    }
    
    void drawFunction(){
      pushStyle();
      fill(0,255,0);
      ellipse(0,0,2,2);
      popStyle();
    }
  }
  class R extends RootModule{
    R( float order){
      super("R", new float[] {}, "");
      addInitialParam("order", order);
    } 
  }
  class Rradial extends Module{
     Rradial( float angle){
      super("Radial", new float[] {angle});
    } 
        String repr(){
      return "";
    }
    
    void drawFunction(){
      getTurtle().Rh(getP());
    }
  }
  class Raxial extends Module{
    Raxial( float angle){
      super("Axial", new float[] {angle});
    } 
    String repr(){
      return "";
    }
    
    void drawFunction(){
      turtle.Rl(getP());
    }
  }
  class Roffshoot extends Module{
    Roffshoot( float angle){
      super("Offshoot", new float[] {angle});
    } 
    
    void drawFunction(){
      turtle.Ru(getP());
    }
  }
}
