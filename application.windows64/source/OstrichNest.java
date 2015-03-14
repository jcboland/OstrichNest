import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.awt.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class OstrichNest extends PApplet {

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
Interface appInter = new Interface();
boolean treeConstructed = false;
int border = 5;
int dots = 1;

public void setup(){
  size(800, 800);
  background(255);
  
  fill(100);
  stroke(100);
  textSize(25);
  textAlign(CENTER, CENTER);
  text("Please wait while your \n computer is analyzed", width/2, height/2);
  thread("createTree");
  
}

public void draw(){

    
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

public void mouseReleased(){
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

public void keyPressed(){
  if(key == BACKSPACE){
    if(currentFolder.getParent() != null){
      currentFolder = currentFolder.getParent();
      createButtons();
      println(currentFolder.getLocation());  
      println(currentFolder.getWeight());
    }

  }
  
}

public void createButtons(){
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
    int butColor = color(250, 109, 43, value+100);
    Button newButton = new Button(width - border*2, butHeight, width/2, 
        border + butHeight/2 + (butHeight+border)*num, butColor, temp.getName());
    newButton.setFolder(temp);
    appInter.addButton(newButton);
    println(newButton.text + "//" + temp.getWeight());
    num++;
  }
}


public void createTree(){
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

public void constructTree(Folder tempFolder){
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
public void folderSelection(File selection){
  rootFolder = selection.getAbsolutePath();
  println("Root folder selected: " + rootFolder);
}

class Button{
  
  int widthBut;
  int heightBut;
  int xpos;
  int ypos;
  int buttonColor;
  String text;
  Folder folder; 
  
  Button(int widthBut, int heightBut, int xpos, int ypos, int buttonColor, String text){
    
    this.widthBut = widthBut;
    this.heightBut = heightBut;
    this.xpos = xpos;
    this.ypos = ypos;
    this.buttonColor = buttonColor;
    this.text = text;
    
  }
  
  public void setFolder(Folder inputFolder){
    this.folder = inputFolder;
  }
  
  public Folder getFolder(){
    return this.folder;
  }
  
  public void display(){
    // Construction Rectangle
  
    noStroke();
    fill(this.buttonColor);
    rect(this.xpos - this.widthBut/2, this.ypos - this.heightBut/2, this.widthBut, this.heightBut);
    fill(25);
    if(this.heightBut < 30){
      textSize(this.heightBut);
    }
    else{
      textSize(25);
    }
    
    textAlign(CENTER, CENTER);
    text(this.text, xpos, ypos-border/2);

  }
 
  public String getLocation(){
    return folder.getLocation();
  }
  
  public boolean pressed(){
    if(mouseX < (xpos + widthBut/2) && mouseX > (xpos - widthBut/2)){
      if(mouseY < (ypos + heightBut/2) && mouseY > (ypos - heightBut/2)){
        return true;
      }
      else{
        return false;
      }
    }
    else{
      return false; 
    }
  }
}
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
  public String getName(){
    return this.name;
  }
  
  public void addChild(Folder child){
    children.add(child);
  }
  
  public ArrayList<Folder> getChildren(){
    return this.children;
  }
  
  public void addLeaf(Leaf newLeaf){
    leaves.add(newLeaf);
  }
  
  public void setParent(Folder newParent){
    this.parent = newParent;
  }
  
  public ArrayList<Leaf> getLeaves(){
    return this.leaves;
  }
  
  public Folder getParent(){
    return this.parent;
  }
  
  public String getLocation(){
    return this.location;
  }
  
  public Long getWeight(){
    return this.weight;
  }
  
  public void setWeight(Long weight){
    this.weight = weight;
  }
  
  
}
class Interface{
  
  ArrayList<Button> buttons;

  Interface(){
    
    this.buttons = new ArrayList<Button>();

  }
  
  public void display(){
     backgroundElements();
     for(Button tempButton : buttons){
        tempButton.display();
     }
  }
  
  public void addButton(Button newButton){
     buttons.add(newButton);     
  }

  
  public Button checkButtonPress(){
    for(Button tempButton : buttons){
      if(tempButton.pressed()){
        return tempButton;
      }
    }
    return null;
  }
  
  public void clearButtons(){
    this.buttons = new ArrayList<Button>();
  }
  
  public void backgroundElements(){
    //Cam Background
    background(255);
    fill(0);
    noStroke();
  
 
  }


 
}
class Leaf{
  String location;
  long weight;
  Folder parent;
  
  Leaf(String location){
    this.location = location;
  }
 
  public String getLocation(){
    return this.location;
  }
  
  public void setWeight(long weight){
    this.weight = weight;
  }
  
  public long getWeight(){
    return this.weight;
  }
  
  public void setParent(Folder parent){
    this.parent = parent;
  }
    
  
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "OstrichNest" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
