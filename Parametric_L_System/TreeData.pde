import java.util.UUID;

static class Tree<T>{
  private Node<T> root;
  public ArrayList<Node<T>> leafNodes;
  
  public Tree(){
    root = new Node<T>();
  }
  
  public Tree(T rootData){
    root = new Node<T>(rootData);
  }
  
  public void getLastBranches(ArrayList<Node<T>> branches, Node<T> node){
    for (int i = 0; i< node.children.size(); i++){
      getLastBranches(branches,node.children.get(i));
    }
    
    if (!node.hasChildren()){  
      branches.add(node);
    }
  }
  
  public ArrayList<Node<T>> getLastBranches(){
    Node<T> node = root;
    ArrayList<Node<T>> branches = new ArrayList<Node<T>>();
    for (int i = 0; i< node.children.size(); i++){
      getLastBranches(branches,node.children.get(i));
    }
    
    if (!node.hasChildren()){  
      branches.add(node);
    }
    return branches;
  }
  
  public int getNumBranches(Node<T> node){
    int retVal = node.numChildren();
    for (Node<T> n: node.getChildren()){
      retVal += getNumBranches(n);
    }
    return retVal;
  }
  
  
  Node<T> getRoot(){
    return root;
  }
  
  void addNode(Node<T> n, T data){
    
     int idx = leafNodes.indexOf(n); 
     Node<T> n2 = n.addChild(data);
    
  }  

}

static class Node<T>{
  public T data;
  private boolean isDirty;
  public boolean isLeaf;
  private Node<T> parent;
  private ArrayList<Node<T>> children;
  public UUID id;
  
  public Node(T data){
    id = UUID.randomUUID();
    this.data = data;
    this.isDirty = true;
    this.isLeaf =true;
    this.children = new ArrayList<Node<T>>();
  }
  
  public Node(){
    this.isLeaf =true;
    this.isDirty = false;
    this.children = new ArrayList<Node<T>>();
  }
  
  Node<T> addChild(T data){
    this.isLeaf =false;
    Node<T> n = new Node<T>(data);
    this.children.add(new Node<T>(data));
    return n;
  }
  
  public T getData(){
    return data;
  }
  
  public ArrayList<Node<T>> getChildren(){
    return this.children;
  }
  
  public boolean hasChildren(){
    return (children.size() >0);
  }
  
  public int numChildren(){
    return children.size();
  }
  
  public boolean isDirty(){
    if (isDirty){
      isDirty = false;
      return true;
    }
    for( Node<T> c : children){
      return c.isDirty();
    }
    return false;
  }
 
}


class WordTree{
  Tree<Module> moduleTree;
  ArrayList<Node<Module>> currentWord;
  ArrayList<Node<Module>> nextWord;

  WordTree(){
    moduleTree = new Tree<Module>();
    currentWord = new ArrayList<Node<Module>>();
    nextWord = new ArrayList<Node<Module>>();
  }
  
  void add(Module m){
    currentWord.add(moduleTree.getRoot().addChild(m));
  }
  
  void add(Node p, Module m){
    int idx = currentWord.indexOf(p);
    nextWord.add(idx, p.addChild(m));
    nextWord.remove(p);
    //p.addChild(m);
  }
  
  void add(Node p, ArrayList<Module> modules){
    int idx = currentWord.indexOf(p);
    for (Module m:modules){
      nextWord.add(idx, p.addChild(m));
      p.addChild(m);
      idx++;
    }
    nextWord.remove(p);
  
  }
  
  ArrayList<Node<Module>> currentWord(){
    nextWord= (ArrayList<Node<Module>>) currentWord.clone();
    return currentWord; 
  }
  
  //ArrayList<Node<Module>> currentWord(){
  //  return moduleTree.getLastBranches(); 
  //}
  
  void updateWord(){
    currentWord = nextWord;
    currentWord= (ArrayList<Node<Module>>) nextWord.clone();
  }
}
