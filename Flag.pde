//The flag remains largly unchanged from it's original state baring the initial translation from Javascript to Java.
class Flag{
  //float x, y;
  int sizex, sizey;
  int team;
  color colour;
  boolean caught = false;
  int enemy;
  Player enemyPlayer;
  PVector start;
  PVector pos;
  
  public Flag(float x, float y, int size, int team){
    //this.x = x;
    //this.y = y;
    sizex = size;
    sizey = size;
    this.team = team;
    this.colour = teams[team];
    enemy = (team == 1 ? 0 : 1);
    enemyPlayer = players.get(enemy);
    start = new PVector(x, y);
    pos = new PVector(x, y);
  }
  
  void update(){
  if(collideRectRect(this.pos.x-(this.sizex)/2, this.pos.y-(this.sizey)/2, this.sizex, this.sizey, 
                       this.enemyPlayer.pos.x-(this.enemyPlayer.sizex)/2, this.enemyPlayer.pos.y-(this.enemyPlayer.sizey)/2, this.enemyPlayer.sizex, this.enemyPlayer.sizey)
      ||
      collideRectRect(this.pos.x-this.sizex/2 -1, this.pos.y - 16, 5, 80, 
                      this.enemyPlayer.pos.x-(this.enemyPlayer.sizex)/2, this.enemyPlayer.pos.y-(this.enemyPlayer.sizey)/2, this.enemyPlayer.sizex, this.enemyPlayer.sizey)
      
      ){
      this.caught = true;  
    }
    if(this.caught){
      this.pos.set(this.enemyPlayer.pos.x,this.enemyPlayer.pos.y - 50); 
      this.enemyPlayer.hasFlag = true;
    }
    if(this.enemyPlayer.dead){
      this.caught = false; 
      this.pos = this.start.copy(); 
      this.enemyPlayer.hasFlag = false;
    }
  }
  
  void show(){
    fill(0);
    rect(this.pos.x-this.sizex/2 -1, this.pos.y - 16, 5, 80);
    rect(this.pos.x-(this.sizex)/2, this.pos.y-(this.sizey)/2, this.sizex, this.sizey); // Collision rect
    
    fill(this.colour);
    rect(this.pos.x-(this.sizex*0.8)/2, this.pos.y-(this.sizey*0.8)/2, this.sizex*0.8, this.sizey*0.8);
  }
}