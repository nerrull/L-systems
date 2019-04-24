import java.util.UUID;

class Tree{
  private NodeWord root;
  public ArrayList<NodeWord> leafNodes;
  public boolean isDirty;
  
  public Tree(){
    root = new NodeWord();
  }
  
  void clear(){
    //recursively delete child nodes
  }
  
  //public void getLastBranches(ArrayList<NodeWord> branches, NodeWord node){
  //  for (int i = 0; i< node.children.size(); i++){
  //    getLastBranches(branches,node.children.get(i));
  //  }
    
  //  if (!node.hasChildren()){  
  //    branches.add(node);
  //  }
  //}
  
  NodeWord getRoot(){
    return root;
  }
  
}
