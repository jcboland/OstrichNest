//*********************************************************************************
// This app is used to visualize and navigate a file structure to 
// determine where there is an excess of data being stored. 
//
// Written by Jack Boland, jcboland91@gmail.com 
// 
// * ----------------------------------------------------------------------------
// * "THE BEER-WARE LICENSE" (Revision 42):
// * <jcboland91@gmail.com> wrote this file.  As long as you retain this notice you
// * can do whatever you want with this stuff. If we meet some day, and you think
// * this stuff is worth it, you can buy me a beer in return.  (Poul-Henning Kamp)
// * ----------------------------------------------------------------------------
//
//**********************************************************************************

String rootFolder;
Folder root;
Folder currentFolder;


void setup(){
  size(800, 800);
  background(255);
  
  // First - prompt the user for the root folder. 
  selectFolder("Select the root folder:", "folderSelection");
  while(rootFolder == null){
  }
  currentFolder = new Folder(rootFolder);
  constructTree(currentFolder);

  long totalWeight = 0;
  ArrayList<Folder> grandChildren = currentFolder.getChildren();
  if(grandChildren.size() > 0){
    for(Folder grandChild : grandChildren){
      totalWeight += grandChild.getWeight();
      //println(totalWeight);
    }
  }
  
  ArrayList<Leaf> grandChildrenLeaf = currentFolder.getLeaves();
  if(grandChildrenLeaf.size() > 0){
    for(Leaf grandChildLeaf : grandChildrenLeaf){
      totalWeight += grandChildLeaf.getWeight();
    }
  }
  currentFolder.setWeight(totalWeight);
}

void constructTree(Folder tempFolder){
  File currFile = new File(tempFolder.getLocation());
  String[] currChildren = currFile.list();
  
  if(currChildren.length > 0){  
    for(String tempChild : currChildren){
      File tempFile = new File(tempFolder.getLocation() + "//" + tempChild);
      if(tempFile.isDirectory()){
        Folder childFolder = new Folder(tempFolder.getLocation() + "//" + tempChild);
        childFolder.setParent(tempFolder);
        tempFolder.addChild(childFolder);
        constructTree(childFolder);
        
        
        long totalWeight = 0;
        ArrayList<Folder> grandChildren = childFolder.getChildren();
        if(grandChildren.size() > 0){
          for(Folder grandChild : grandChildren){
            totalWeight += grandChild.getWeight();
            //println(totalWeight);
          }
        }
        
        ArrayList<Leaf> grandChildrenLeaf = childFolder.getLeaves();
        if(grandChildrenLeaf.size() > 0){
          for(Leaf grandChildLeaf : grandChildrenLeaf){
            totalWeight += grandChildLeaf.getWeight();
          }
        }
        childFolder.setWeight(totalWeight);
        
      }
      else{
        Leaf tempLeaf = new Leaf(tempFolder.getLocation() + "//" + tempChild);
        File leafFile = new File(tempLeaf.getLocation());
        tempLeaf.setParent(tempFolder);
        tempLeaf.setWeight(leafFile.length());
        //println(leafFile.length());
        tempFolder.addLeaf(tempLeaf);
        //println(tempLeaf.getLocation());
      }
    }
  } 
}

void draw(){
  
 
}

void keyPressed(){
  if(key == BACKSPACE){
    currentFolder = currentFolder.getParent();
    println(currentFolder.getLocation());  
    println(currentFolder.getWeight());
  }
  else{
    ArrayList<Folder> folderList = currentFolder.getChildren();
    currentFolder = folderList.get(key-48);
    println(currentFolder.getLocation());
    println(currentFolder.getWeight());
  }
  
}


// Called once an action occurs using the folder selection prompt
void folderSelection(File selection){
  rootFolder = selection.getAbsolutePath();
  println("Root folder selected: " + rootFolder);
}
