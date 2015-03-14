class Folder{
  ArrayList<Folder> children;
  ArrayList<Leaf> leaves;
  Folder parent;
  String location;
  long weight;
  String name;
  
  Folder(String location){
    this.location = location + "\\";
    this.children = new ArrayList<Folder>();
    this.leaves = new ArrayList<Leaf>();
    
    String[] items = split(this.location, "\\");    
    this.name = items[items.length-2];
    

  }
  String getName(){
    return this.name;
  }
  
  void addChild(Folder child){
    children.add(child);
  }
  
  ArrayList<Folder> getChildren(){
    return this.children;
  }
  
  void addLeaf(Leaf newLeaf){
    leaves.add(newLeaf);
  }
  
  void setParent(Folder newParent){
    this.parent = newParent;
  }
  
  ArrayList<Leaf> getLeaves(){
    return this.leaves;
  }
  
  Folder getParent(){
    return this.parent;
  }
  
  String getLocation(){
    return this.location;
  }
  
  Long getWeight(){
    return this.weight;
  }
  
  void setWeight(Long weight){
    this.weight = weight;
  }
  
  
}
