
PVector orientation;
import java.util.*; 

static interface ParametricRule {
    ArrayList<Module> rule(Module m);
}

class Module{
  String letter;
  HashMap<String, Float> parameters;
  
  Module(String l){
    letter = l;
    parameters = new HashMap<String, Float>();
  }
  Module(String l, HashMap<String, Float> p){
    letter = l;
    parameters = p;
  }
  
  void addParam(String name, float value){
      parameters.put(name, value);
  }
  
  void updateParam(String s, float v){
    parameters.replace(s, v);
  }
  
  void drawFunction(){
    return;
  }
  void drawFunction(PShape p){
    drawFunction();
  }
  
  float getP(String s){
    return parameters.get(s);
  }
  
  String repr(){
    return this.letter;
  }
  
  Module grow(){
    return this;
  }
    
}

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

class ParametricLSystem{
  int updateNumber =0;
  HashMap<String, ParametricRule> rules;
  Word word;
  ArrayList<UUID> toRemove;
  boolean finished = false;
  ArrayList<ArrayList<Module>> segments;
  
  float xPos = 0;
  float yPos = 0;
  float zPos = 0;

  ParametricLSystem(){
    rules = new HashMap<String, ParametricRule>();
    toRemove = new ArrayList<UUID>();
    word = new Word();
    segments = new ArrayList<ArrayList<Module>>(1024);
  }
  
  //Could be generating alot of garbage
  void update(){
    updateNumber ++;
    Word newWord=  new Word();
    Iterator<Module> iter  = word.modules.iterator();
    Module m;
    while (iter.hasNext()){
      m =iter.next();
      if (m.letter =="%"){
        while(m.letter != "-%"){
          m = iter.next();
        }
        m = iter.next();
      }
      if(rules.containsKey(m.letter)){
        newWord.add(rules.get(m.letter).rule(m));
      }
      else{
        newWord.add(m);
      }
    }
    word = newWord;
  }
  
  
  
  float updateSegments(){
    updateNumber ++;
    
    if (finished){
      return 0 ;
    }
    segments.clear();
    word.getSegments(segments);
    if (updateNumber >100 && segments.size() ==1){
      finished =true;
    }
    word.clear();
    //Word newWord=  new Word(word);

    for(UUID id : toRemove){
       turtle.removeSegment(id);
       newWord.removeId(id);
    }
    toRemove.clear();

    Module m;
    Segment seg;
    boolean isDirty;
    int nDirty =0;
    int index =0;
    
    Iterator<ArrayList<Module>> iter  = segments.iterator();
    ArrayList<Module> segment;
    ArrayList<Module> newSegment= new ArrayList<Module>();
    while (iter.hasNext()){
      newSegment.clear();
      segment = iter.next();
      Iterator<Module> m_iter = segment.iterator();
      //Segment is always first module
      try {
        seg =(Segment) m_iter.next();
      }
      catch(Exception e) {
        break; //<>//
      }
      newSegment.add(0,seg);
      isDirty = false;
      while (m_iter.hasNext()){
         m = m_iter.next();
        if(rules.containsKey(m.letter)){
          isDirty=true;
          newSegment.addAll(rules.get(m.letter).rule(m));
        }
        else{
          newSegment.add(m);
        }
      }
      if (isDirty){
        nDirty++;
        turtle.updateSegment(seg.id, newSegment);
      }
      else{

        if (index >0){
          //newSegment.remove(seg);
          //newSegment.add(0,new SegmentMerge());
          turtle.goTo(seg.id);
          //toRemove.add(seg.id);
        }
        else{
          turtle.goTo(seg.id);
        }
      }
      newWord.add(newSegment);
      index ++;
    }
    word = newWord;
    return nDirty;
  }
  
  void printWord(){
    for( Module m: word.modules){
      print(m.repr());
    }
    println();
    println();

  }
  
  void drawSystemSegments(){
    pushMatrix();
    pushStyle();
    turtle.moveTo(xPos, yPos, zPos);
    turtle.drawSegments(word.segmentIDs);
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
  
  void setGrowthRate(float g){
    
  }
    
  void setSizeFactor(float f){
    
  }
  void setPosition(float px,float py, float pz){
    this.xPos = px;
    this.yPos =py;
    this.zPos =pz;

  }
  void setPosition(float px,float py){
    this.xPos = px;
    this.yPos =py;
  }
  
  PVector getPosition(){
    return new PVector(this.xPos, this.yPos, this.zPos);
  }
}
