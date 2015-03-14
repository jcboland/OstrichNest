class Interface{
  
  ArrayList<Button> buttons;

  Interface(){
    
    this.buttons = new ArrayList<Button>();

  }
  
  void display(){
     backgroundElements();
     for(Button tempButton : buttons){
        tempButton.display();
     }
  }
  
  void addButton(Button newButton){
     buttons.add(newButton);     
  }

  
  Button checkButtonPress(){
    for(Button tempButton : buttons){
      if(tempButton.pressed()){
        return tempButton;
      }
    }
    return null;
  }
  
  void clearButtons(){
    this.buttons = new ArrayList<Button>();
  }
  
  void backgroundElements(){
    //Cam Background
    background(255);
    fill(0);
    noStroke();
  
 
  }


 
}
