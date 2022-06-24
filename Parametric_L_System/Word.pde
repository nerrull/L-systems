
class Word{
  ArrayList<Module> modules;
  ArrayList<UUID> segmentIDs;
  ArrayList<Module> segment;
  
  Word(){
    modules=  new ArrayList<Module>();
    segmentIDs = new  ArrayList<UUID>();
    segment = new ArrayList<Module> (1024);
  }
  
  Word(Word word){
    modules=  new ArrayList<Module>();
    segmentIDs = new  ArrayList<UUID>(word.segmentIDs);
    segment = new ArrayList<Module> (1024);
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
  void removeId(UUID id){
    segmentIDs.remove(id);
  }
  
  ArrayList<ArrayList<Module>> getSegments(ArrayList<ArrayList<Module>> segments){
    segment.clear();
    segmentIDs.clear();
    int seg_count=0;
    for (Module m :modules){
      if (m.letter == "SEG"){
        Segment s= (Segment) m;
        segmentIDs.add(s.id);
        seg_count++;
        if (seg_count >1){
          segments.add(new ArrayList<Module>(segment));
          segment.clear();
          segment.add(m);
          continue;
        }
      }
      segment.add(m);
    }
    segments.add(new ArrayList<Module>(segment));
    return segments;
  }
}


class WordTree{
  Tree tree;
  ArrayList<UUID> segmentIDs;
  ArrayList<Module> segment;
  
  WordTree(){
    tree=  new Tree();
    tree.root = new NodeWord();
  }
  
  void add(ArrayList<Module> m){
    tree.root.addChild(m);
  }  
  
  void init(ArrayList<Module> m){
    tree.root = new NodeWord(m);
  }  
  
  void clear(){
    tree.clear();
  }

  void printWord(){
    tree.root.printWord();
    return;
  }
  
  void updateRootState(TurtleState ts){
    tree.root.setTurtleState(ts);
  }
  
  int update(HashMap<String, ParametricRule> rules, float growth_step){
    int ndirty =0;
    tree.root.update(ndirty, rules, growth_step);
    //print("N-dirty nodes " + ndirty);
    return ndirty;
  }
  
  boolean isDone(){
    return(tree.root.isDone());
  }
  
  void parse(){
    tree.root.parse();
  }

  void draw(PGraphics  p){
    tree.root.drawShape(p);
  }
}

class NodeWord{
  ArrayList<Module> modules;
  ArrayList<Module> oldModules;
  ArrayList<Module> toRemove;
  HashMap<UUID, NodeWord> children;
  ArrayList<Pair<Integer, Module>> toAdd;
  public UUID id;
  private boolean isDirty;
  public boolean isDone;
  private boolean isLeaf;
  private NodeWord parent;
  public WordShape shape;
  
  void init(){
    toAdd= new ArrayList<Pair<Integer, Module>>(4);
    modules= new ArrayList<Module>(1024);
    toRemove= new ArrayList<Module>(1024);
    children = new HashMap<UUID, NodeWord>(16);
    id = UUID.randomUUID();
    shape = new WordShape();
    isDirty = true;
    isLeaf = true;
  }
  
  NodeWord(){
    init();
  }
  
  void add(Module m){
    modules.add(m);
  }
  
  NodeWord(ArrayList<Module> m){
    init();
    modules.addAll(m);
  }
  
  void update(int ndirty, HashMap<String, ParametricRule> rules, float growth_step){
    isDirty= false;

    if (! this.isDone){
      oldModules = new ArrayList<Module>(modules);
      Iterator<Module> it =oldModules.iterator();
      modules.clear();
      Module m;
      this.isDone = true;
      while(it.hasNext()){
        m = it.next();
        if(rules.containsKey(m.letter)){
          boolean d =rules.get(m.letter).rule(m,modules, growth_step);
          isDirty = (isDirty ||d);
          isDirty= true;
          this.isDone =false;
        }
        else if(m.letter == "["){
          isDirty = true;
        }
        else if(m.letter == "Fill"){
          this.shape.shapeType = SOLID_SHAPE;
          modules.add(m);
        }
        else if(m.letter == "White"){
          this.shape.fillColor = color(255);
          modules.add(m);
        }
        else if(m.letter == "]"){
          isDirty = true;
        }
        else{
          modules.add(m);
        }
      }
    }
    for (NodeWord child :  this.getChildren()){
      child.update(ndirty,rules, growth_step);
    }
  }
  
  boolean isDone(){
    boolean d = isDone;
    
    for (NodeWord child :  this.getChildren()){
      d = d && child.isDone();
    }
    return d;
  }
  
  //parse m and update shape
  void parse(){
    if (this.isDirty){
      toAdd.clear();
      Iterator<Module> it =modules.iterator();
      int index =0;
      Module m;
      //while parsing 
      while(it.hasNext()){
        m = it.next();
        //if [ extract child and add new ID module
        if(m.letter == "["){
          toRemove.add(m);
          // Iterator<Module> e_it = modules.listIterator(index);
          index =extractChild(it, index);
        }
        index++;
      }
      
      //Insert all new id modules
      Iterator<Pair<Integer, Module>> pit = toAdd.iterator();
      Pair<Integer, Module> p;
      while(pit.hasNext()){
        p = pit.next();
        modules.add(p.getKey(), p.getValue());
      }
      this.modules.removeAll(toRemove);
      this.toRemove.clear();
      
      //update shape
      this.shape.generateShape(this.modules.iterator(), children );
    }
          //this.shape.printword(this.modules);
          
    if (this.isDone){
      if (this.shape.n_draws >1){
        this.shape.generateShape(this.modules.iterator(),  children, true);
      }
    }
    for (NodeWord child :  this.getChildren()){
      child.parse();
    }
    isDirty =false;  
  }

  void printWord(){
    print ( "~(");
    if (isDone){
        print("DONE");
    }
    for(Module m : modules){

      print(m.repr());
      if (m.letter == "ID"){
        ID i = (ID) m;
        children.get(i.id).printWord();
      }
      
    }
    print ( ")~"); //<>//

  }
  
  //<>// //<>// //<>//
  void drawShape(PGraphics p){
    p.pushMatrix();
    shape.translate(p); 
    this.shape.drawShape(p);
    for (NodeWord child :  this.getChildren()){
      child.drawShape(p);
    }
    p.popMatrix();
  }
  
  int extractChild(Iterator<Module> it, int index){
    int depth = 0;
    ArrayList<Module> n = new ArrayList<Module>(1024);
    Module m;
    //Skip first bracket and remove it
    while(it.hasNext()){
      index++;
      m = it.next();
      toRemove.add(m);
      //add modules to n
      if (m.letter == "["){
        depth++;
      }
      else if (m.letter == "]" && depth >0){
        depth--;
      }
      else if (m.letter == "]" && depth ==0){
        break;
      }
      n.add(m);
    }
    ID id = new ID(this.addChild(n));
    toAdd.add(new Pair<Integer, Module>(index, id));
    return index;
  }
  
  UUID addChild(ArrayList<Module> modules){
    NodeWord child = new NodeWord(modules);
    children.put(child.id, child);
    isLeaf= false;
    return child.id;
  }
  
  void setTurtleState(TurtleState s){
    this.shape.setTurtleState(s);
  }
  
  void updateTurtleState(TurtleState ts){
     this.shape.setTurtleState(ts);
  }
  
  
  ArrayList<NodeWord> getChildren(){
    return new ArrayList<NodeWord>(children.values());
  }
  
  
}
