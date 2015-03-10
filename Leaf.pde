class Leaf{
  String location;
  long weight;
  Folder parent;
  
  Leaf(String location){
    this.location = location;
  }
 
  String getLocation(){
    return this.location;
  }
  
  void setWeight(long weight){
    this.weight = weight;
  }
  
  long getWeight(){
    return this.weight;
  }
  
  void setParent(Folder parent){
    this.parent = parent;
  }
    
  
}
