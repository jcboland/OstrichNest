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

import java.awt.*;

String rootFolder;
Folder root;
Folder currentFolder;
Interface appInter = new Interface();
boolean treeConstructed = false;
int border = 5;
int dots = 1;

void setup(){
  size(800, 800);
  background(255);
  
  fill(100);
  stroke(100);
  textSize(25);
  textAlign(CENTER, CENTER);
  text("Please wait while your \n computer is analyzed", width/2, height/2);
  thread("createTree");
  
}

void draw(){

    
  if(treeConstructed != true){
    background(255);
    fill(100);
    stroke(100);
    textSize(20);
    textAlign(CENTER, CENTER);
    text("Please wait while your \n computer is analyzed", width/2, height/2);
    if(dots == 1){
      ellipse(width/2 - 90, height/2 + 50,  5, 5);
    }
    if(dots == 2){
      ellipse(width/2 - 90, height/2 + 50,  5, 5);
      ellipse(width/2 - 30, height/2 + 50,  5, 5);
    }
    if(dots == 3){
      ellipse(width/2 - 90, height/2 + 50,  5, 5);
      ellipse(width/2 - 30, height/2 + 50,  5, 5);
      ellipse(width/2 + 30, height/2 + 50,  5, 5);
    }
    if(dots == 4){
      ellipse(width/2 - 90, height/2 + 50,  5, 5);
      ellipse(width/2 - 30, height/2 + 50,  5, 5);
      ellipse(width/2 + 30, height/2 + 50,  5, 5);
      ellipse(width/2 + 90, height/2 + 50,  5, 5);
    }
 
    dots++;
    if(dots == 5){
      dots = 1;
    }
    delay(500);
    
  }
  else{
    appInter.display();
  }
  
}

void mouseReleased(){
  if(mouseEvent.getClickCount()==2){
    println("Double Click");
    Button tempButton = appInter.checkButtonPress();
    if(tempButton != null){  
      File file = new File(tempButton.getLocation());
      Desktop desktop = Desktop.getDesktop();
      try{
        desktop.open(file);
      }
      catch(IOException e){
        println("Cannot Open Location");
      }
    }
  }
  else{
    Button tempButton = appInter.checkButtonPress();
    println("Mouse Pressed");
    if(tempButton != null){  
      if(tempButton.getFolder().getChildren().size() != 0){
        currentFolder = tempButton.getFolder();
        createButtons();
        println(tempButton.getLocation());
      }
    }
  }
  
}

void keyPressed(){
  if(key == BACKSPACE){
    if(currentFolder.getParent() != null){
      currentFolder = currentFolder.getParent();
      createButtons();
      println(currentFolder.getLocation());  
      println(currentFolder.getWeight());
    }

  }
  
}

void createButtons(){
  appInter.clearButtons();
  ArrayList<Folder> currChildren = currentFolder.getChildren();
  //long totalWeight = currentFolder.getWeight();
  int totalChildren = currChildren.size();
  int num = 0;
  
  //Button(int widthBut, int heightBut, int xpos, int ypos, color buttonColor, String text)
  for(Folder temp : currChildren){
    
    float ratio = (float)temp.getWeight()/(float)currentFolder.getWeight();
    int butHeight = (height - border*(totalChildren + 1))/totalChildren;
    float value = ratio * 255;
    color butColor = color(250, 109, 43, value+100);
    Button newButton = new Button(width - border*2, butHeight, width/2, 
        border + butHeight/2 + (butHeight+border)*num, butColor, temp.getName());
    newButton.setFolder(temp);
    appInter.addButton(newButton);
    println(newButton.text + "//" + temp.getWeight());
    num++;
  }
}


void createTree(){
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
  createButtons();
  treeConstructed = true;

}

void constructTree(Folder tempFolder){
  File currFile = new File(tempFolder.getLocation());
  String[] currChildren = currFile.list();
  
  if(currChildren != null){
    if(currChildren.length > 0){  
      for(String tempChild : currChildren){
        File tempFile = new File(tempFolder.getLocation() + "\\" + tempChild);
        if(tempFile.isDirectory()){
          Folder childFolder = new Folder(tempFolder.getLocation() + "\\" + tempChild);
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
          Leaf tempLeaf = new Leaf(tempFolder.getLocation() + "\\" + tempChild);
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
}


// Called once an action occurs using the folder selection prompt
void folderSelection(File selection){
  rootFolder = selection.getAbsolutePath();
  println("Root folder selected: " + rootFolder);
}
