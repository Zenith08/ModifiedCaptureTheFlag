//Obstacles are slightly modified from the original to move to a new position based on it's id.
public class Obstacle{
  float sizex, sizey; //The width and height of the obstacle at this current time.
  PVector pos; //The position in 2d space of this obstacle.
  byte mode = 0; //The mode of an obstacle defines which map to use in calculations. It can be changed on the fly.
  final byte id; //The id of an obstacle tells it which box this obstacle is and allows it to draw its coordinates.
  final int SPEED = 7; //The speed at which the obstacle will move to a new position
  
  //Spot refers to an id. Each obstacle has an id and keeps it through each mode available. It will change modes and use its id to get its new position.
  public Obstacle(byte spot){
    mode = 0; //Mode 0 is a default.
    id = spot; //We need to safe this.
    pos = new PVector(maps.maps[mode][id][0], maps.maps[mode][id][1]); //Sets position and dimensions based on the map and this id.
    this.sizex = maps.maps[mode][id][2];
    this.sizey = maps.maps[mode][id][3];
  }
  
  void show(){
    fill(0);
    rect(this.pos.x-this.sizex/2, this.pos.y-this.sizey/2, this.sizex, this.sizey);
    //This text can be used to visualize how the map will be built durring a map transition.
    /*fill(255);
    text("" + id, this.pos.x, this.pos.y);*/
  }
  
  void update(){
    //This simple logic slowly moves the variables to their targets while not overshooting. Each variable uses the same logic
    pos.x = approachNumber(pos.x, maps.maps[mode][id][0], SPEED);
    pos.y = approachNumber(pos.y, maps.maps[mode][id][1], SPEED);
    sizex = approachNumber(sizex, maps.maps[mode][id][2], SPEED);
    sizey = approachNumber(sizey, maps.maps[mode][id][3], SPEED);
  }
  
  void changeMode(byte newMode){
    mode = newMode;
  }
  
  public float approachNumber(float initial, float target, float speed){
    float approach = 0; //Gives us something to manipulate so we don't need to work on the main arguments.
    if(initial < target){ //If we need to increase the number to reach the target
      if(initial+speed > target){ //Then make sure we won't overshoot the target.
        approach = target; //If we will, then we are at the target exactly.
      }else{ //If not
        approach = initial+speed; //Then add speed on to the number.
      }
    }else if(initial > target){ //Else if we need to decrease the number towards the target
      if(initial-speed < target){ //Then make sure we won't go below the target
        approach = target; //If we will, then we are at the target exactly.
      }else{ //If not
        approach = initial-speed; //Then reduce speed from the number.
      }
    }else{ //If the initial is not greater than or less than the target
      approach = initial; //Then it is equal to the target
    }
    return approach;
  }
}