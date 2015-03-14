
class Button{
  
  int widthBut;
  int heightBut;
  int xpos;
  int ypos;
  color buttonColor;
  String text;
  Folder folder; 
  
  Button(int widthBut, int heightBut, int xpos, int ypos, color buttonColor, String text){
    
    this.widthBut = widthBut;
    this.heightBut = heightBut;
    this.xpos = xpos;
    this.ypos = ypos;
    this.buttonColor = buttonColor;
    this.text = text;
    
  }
  
  void setFolder(Folder inputFolder){
    this.folder = inputFolder;
  }
  
  Folder getFolder(){
    return this.folder;
  }
  
  void display(){
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
 
  String getLocation(){
    return folder.getLocation();
  }
  
  boolean pressed(){
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
