//The button is derrived from the processing tutorial on this topic
class Button{
  //The buttons 2d position in space
  PVector position;
  //Size of the button, width and height.
  float sizex, sizey;
  //String to show on the button
  String display;
  //The colours of the inside and border of the button.
  color inside;
  color border;
  
  //Default constructor takes in all variables and sets the appropriate internal values.
  public Button(float x, float y, float w, float h, String text, color box, color edge){
    position = new PVector(x, y);
    sizex = w;
    sizey = h;
    display = text;
    inside = box;
    border = edge;
  }
  
  //Show renders the button to the screen and draws the text for the button.
  public void show(){
    //Setup colours and draw rect.
    fill(inside);
    stroke(border);
    rect(position.x, position.y, sizex, sizey);
    //Then setup for drawing text and do it.
    noStroke();
    fill(255, 255, 255);
    text(display, position.x + sizex/2, position.y + sizey/2 + 10);
  }
  
  //Checks if the mouse positioned at x, y is overtop of the button.
  //If it is true is returned otherwise it will be false.
  public boolean pressed(int x, int y){
    //Simple 2d box logic checks if a point is within a defined rectangle.
    if(x > position.x && x < position.x+sizex && y > position.y && y < position.y+sizey){
      return true;
    }else{
      return false;
    }
  }
}