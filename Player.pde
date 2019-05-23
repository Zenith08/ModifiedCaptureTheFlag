//The player class is not appreciably modified from its original state.
//The only key changes include its win handling calling a runCountdown instead of just resetting the game.
//Additionally, collision handling was updated to allow Java to work.
//Not many comments because most of this code is spaghetti code.
public class Player{
  int sizex, sizey;
  int team;
  int enemy;
  color colour;
  int[] controls;
  boolean hasFlag = false;
  int score = 0;
  boolean dead = false;
  boolean killable = true;
  int timer = 0;
  int alpha = 255;
  int zone;
  PVector start;
  PVector pos;
  PVector vel;
  Player enemyPlayer;
  
  public Player(float x, float y, int size, int team){
    this.sizex = size;
    this.sizey = size;
    this.team = team;
    this.enemy = (team == 1 ? 0 : 1);
    this.colour = teams[team];
    controls = new int[4];
    for(int i = 0; i < 4; i++){
     controls[i] = allcontrols[team][i];  
    }
    zone = team;
    start = new PVector(x, y);
    pos = new PVector(x, y);
    vel = new PVector(0, 0);
    vel.limit(speed);
  }
  
  void update(){
    this.enemyPlayer = players.get(enemy);
    if(!this.dead && gameState == game){
      if(keyIsDown(this.controls[0])){this.vel.y -= speed;} // Up
      if(keyIsDown(this.controls[1])){this.vel.x -= speed;} // Left
      if(keyIsDown(this.controls[2])){this.vel.y += speed;} // Down
      if(keyIsDown(this.controls[3])){this.vel.x += speed;} // Right
      this.pos.add(this.vel);
      this.vel.mult(0.95); // Friction to slow you down
    }// If dead...
    else{
      if(this.timer <= 0){ // Check if no longer dead and reset variables
        this.dead = false;
        this.timer = 5 * 60;
        this.alpha = 255;
      }
      else{
        this.timer --;
      }
    }
    
    this.checkZone(); // Find out what zone to check whether or not you can be killed
  }
  
  void checkZone(){
    if(this.pos.x < w/2){
      if(this.pos.x < safety){
        this.touchdown(); 
      }
      else{this.zone = 0; this.killable = true;}
    }
      
    if(this.pos.x > w/2){
      if(this.pos.x > w-safety){
        this.touchdown();
      }
      else{this.zone = 1; this.killable = true;}
    }
    
  } // Close checkZone 
  
  void touchdown(){
      if(this.zone == this.team){
        if(this.hasFlag){
          this.score ++;
          this.die();   
          this.enemyPlayer.die();
          //The particles that play to end the game are activated by a helper method in the main file.
          if(team == 0){
            endParticles(pmRed);
          }else{
            endParticles(pmBlue);
          }
          runCountdown(); //Running the countdown indicates another game is about to begin and lets the system setup for it.
        }
      }
      else{this.killable = false;}  
 }
  
  void show(){ //Simplified to only call rect() once.
    // Black box
    strokeWeight(4);
    stroke(0, this.alpha);
    fill(this.colour);
    rect(this.pos.x-this.sizex/2, this.pos.y-this.sizey/2, this.sizex, this.sizey);
    //Clean up at the end of the render.
    noStroke();
    strokeWeight(1);
  }
  
  void die(){
    if(this.killable){
      deathParticles(pos.copy()); //Spawns the death particles where the player died. This needs to happen before we move back to the spawnpoint.
      this.dead = true;
      this.pos = this.start.copy();
      this.timer = respawn * 60;
      this.alpha = 120;
      this.vel.set(0,0);
    }
}

void collideEnemy(){
  Player other = enemyPlayer;
    if(collideRectRect(this.pos.x-this.sizex/2, this.pos.y-this.sizey/2, this.sizex, this.sizey, other.pos.x-other.sizex/2, other.pos.y-other.sizey/2, other.sizex, other.sizey)){
      if(!this.dead){ // If the other object is a player, push them back and see if they die,, but only if you are allive
        other.vel.add(this.vel);
        //other.pos.add(other.vel);
        if(other.zone != other.team){
          other.die();
        }
      }
      
      this.vel.mult(-0.8); // Bounce back
      this.pos.add(this.vel);
    }
}

void collide(Obstacle other){
  if(collideRectRect(this.pos.x-this.sizex/2, this.pos.y-this.sizey/2, this.sizex, this.sizey, other.pos.x-other.sizex/2, other.pos.y-other.sizey/2, other.sizex, other.sizey)){
      this.vel.mult(-0.8); // Bounce back
      this.pos.add(this.vel);
    }
}

}