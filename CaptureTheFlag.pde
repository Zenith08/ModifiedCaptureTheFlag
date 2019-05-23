import java.util.Random;

//Constants provided fromt the original program. Makes things universally available.
int windowWidth = 1920;
int windowHeight = 919;
final int targetFPS = 60;
//More base constants used for map object placement.
int w = 1920;
int h = 919;
int cx = w/2;
int cy = h/2;
// Team colours, controls, and starting positions
color[] teams = {color(255, 20, 20), color(35, 180, 255)};
//color[] altTeams = {color(0, 255, 0), color(255, 255, 0)};
int [][] allcontrols = {{87, 65, 83, 68},{UP, LEFT, DOWN, RIGHT}};
float [][] starts = {{200, h/2}, {w-200, h/2}};
float [][] flagstarts = {{90, h/2}, {w-90, h/2}};

//What map are we currently on?
int current = 0;

//Maps are now held by a container class to allow easy organization within the code.
Maps maps = new Maps();

// Max velocity of the players
int maxSpeed = 8;
float speed = 0.5;
  
//players = [];
ArrayList<Player> players = new ArrayList<Player>();
//obstacles = [];
ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
//flags = []
ArrayList<Flag> flags = new ArrayList<Flag>();

// How large the "safety strip" is on both sides
int safety = 60;
  
// How long it takes to respawn (in seconds)
int respawn = 3;
  
//Because we need to check if a key is being pressed at any time, this lets us store that information using only the pressed and released events.  
HashMap<Integer, Boolean> keypress = new HashMap<Integer, Boolean>();

//Easy random map selection
Random rand = new Random();
//How long we wait at the start of the game.
final int countdownTime = 5;

final int standby = 0; //Indicates a countdown is running
final int game = 1; //Indicates normal gameplay.
final int endRed = 2; //Indicates the game has ended with red winning.
final int endBlue = 3; //Indicates the game has ended with blue winning.
int gameState = standby; //The current state.
final int maxCountdownFrames = targetFPS*countdownTime; //How many frames we plan to wait before the gmae begins.
int countdownFrames = maxCountdownFrames; //The number of frames left in the current countdown.
final int maxFramesPerNum = targetFPS; //How many frames until we take 1 off of the countdown.
int framesPerNum = maxFramesPerNum; //How many frames left for this number of the countdown.
int dispNumber = countdownTime; //The number of seconds to go which can be drawn to the screen.

int mapCountdown = 5*60; //How many frames until we need a new map.

ParticleSystem gameParticles = new ParticleSystem(0, 0); //Yellow particles to start the game.

ParticleSystem redParticles = new ParticleSystem(1, 0); //Red particles to show blue has captured the red flag.
ParticleSystem blueParticles = new ParticleSystem(2, 0); //Blue particles for red capturing the flag.
ParticleSystem deathParticles = new ParticleSystem(new PVector(0, 0), 0); //White particles that play when a player dies.

int framesSinceEnd = 0; //How long has it beens since the game has ended? Used for postGameAnimation.
FallingParticleSystem leftParts; //End game particles which appear like fireworks.
FallingParticleSystem rightParts;
Button playAgain; //Lets the players play another game.
//Button endGame; Should end the game but instead it just plain crashes the renderer.

void setup() {
  //createCanvas(windowWidth, windowHeight);
  //createCanvas(1920, 919);
  size(1920, 919, FX2D); //Use FX2D for performance gains over the default renderer
  
  //print(windowWidth/width + " " + windowHeight/height)
  //Setup constants and define basic information
  frameRate(targetFPS);
  background(255);
  //rectMode(CENTER);
  textAlign(CENTER);
  noStroke();
  textSize(32);
  //Set the current map to a random map.
  current = rand.nextInt(4);
  
  // Add in new players. Only 2 of them.
  for(int i = 0; i < 2; i++){
    Player temp = new Player(starts[i][0], starts[i][1], 45, i);
    players.add(temp);
  }
  
  // Put in all the obstacles.
  for(byte i = 0; i < maps.map1.length; i++){
    obstacles.add(new Obstacle(i));
  }
  
  // Spawn the flags for each of the two players.
  for(int i = 0; i < 2; i++){
    flags.add(new Flag(flagstarts[i][0], flagstarts[i][1], 35, i));
  }
  
  //Indicates we should setup the data to countdown to the game starting.
  runCountdown();
}

void draw() {
  //Clear the previous frame
  background(200);
  //Window scaling for resizing the window.
  scale(windowWidth/1920, windowHeight/919);
  
  // Draw both coloured halves
  fill(teams[0]);
  rect(safety,0,cx, h);
  fill(teams[1]);
  rect(cx,0,cx-safety, h);
  
  //Update the position of obstacles and then draw them to the screen.
  for(int o = 0; o < obstacles.size(); o++){
    obstacles.get(o).update();
    obstacles.get(o).show();
  }
  
  //For each player
  for(int i = 0; i < players.size(); i++){
    //Check if they collide with any obstacle
    for(int j = 0; j < obstacles.size(); j++){
      players.get(i).collide(obstacles.get(j));
    }
    //Then update them
    players.get(i).update();
    //Check if they collide with their enemy.
    players.get(i).collideEnemy();
    //Then render them.
    players.get(i).show();
    
    //Alternate game handling scores for a best 3 out of 5 game and displays it.
    //Draws each players score above the players spawnpoint.
    for(float k = 0; k < 3; k++){ //Max 3 circles
      if(players.get(i).score > k){ //If they have won enough games, the circle is filled in, otherwise it is left empty.
        fill(0, 255, 0); 
        fill(0, 255, 0);
      }else{
        noFill();
        stroke(255, 255, 0);
      }
      ellipse(players.get(i).start.x + (k-1)*50, players.get(i).start.y-400, 20, 20); //Draws the circle based on information available.
    }
    if(players.get(i).score == 3){ //The condition for winning
      gameState = endRed+players.get(i).team; //Red team is 0 so endRed+0 = endRed. Blue team is 1 so endRed+1 = endBlue.
    }
    //Clean up before the rest of the rendering runs otherwise it causes issues.
    noStroke();
  }
  
  // Show the flags
  for(int i = 0; i < flags.size(); i++){
    flags.get(i).update(); //Check for collisions and stuff.
    flags.get(i).show(); //Draw to screen.
  }
  
  //Derrived from https://www.openprocessing.org/sketch/453716
  if(gameState == standby){ //If we are counting down
    countdownFrames--; //Reduce counts
    framesPerNum--;
    
    if(countdownFrames <= 0){ //Then if it is time to start
      gameState = game;
      gameParticles = new ParticleSystem(pmStart, 100); //Play the starting particles
    }else if(framesPerNum <= 0){
      dispNumber--;
      framesPerNum = targetFPS; //Otherwise reduce the number
    }
    //In a 5 second countdown we only want to show 3, 2, and 1 so this is to check that.
    //But it should run regardless what else is happening
    if(dispNumber <= 3){
      fill(color(255, 255, 0));
      text(dispNumber, w/2, h/2); //Draws the number in the middle of the screen.
    
      //Draws the gradually reducing circle to the screen.
      noFill();
      stroke(color(255, 255, 0));
      float maxBuf = maxFramesPerNum;
      float curBuf = framesPerNum;
      float endPoint = TWO_PI * curBuf / maxBuf;
      //System.out.println("End is " + endPoint);
      arc(w/2, h/2, 200, 200, -HALF_PI, -HALF_PI+endPoint);
      noStroke();
      //System.out.println("Display num = " + dispNumber + " With CDFPS = " + countdownFrames);
    }
  }else if(gameState == game){ //We only want to change the map in gameplay.
    mapCountdown--; //Countdown until map change
    if(mapCountdown == 0){
      changeMap(); //Then change the map.
      mapCountdown = rand.nextInt(10*targetFPS) + 10*targetFPS; //Sets the time until next map change to be between 10 seconds and 20 seconds.
    }
  }else if(gameState == endRed || gameState == endBlue){ //If the game has ended, but regardless of winner
    framesSinceEnd++; //Lets us track animation time.
    if(framesSinceEnd == 1){ //Our first frame of game end can setup info.
      int winner; //We just need this for the particle system.
      if(gameState == endRed){
        winner = 0;
      }else{
        winner = 1;
      }
      //The "Fireworks" particles at the end of the game
      leftParts = new FallingParticleSystem(new PVector(cx-200, cy-50), winner);
      rightParts = new FallingParticleSystem(new PVector(cx+200, cy-50), winner);
      //A button allowing the player to try again.
      playAgain = new Button(cx-100, cy+50, 200, 50, "Play Again", color(128, 128, 128), color(72, 72, 72));
    }
    
    //Fades the screen to black.
    float translucency = framesSinceEnd*2; //Twice the speed so it doesn't take so long.
    if(translucency > 255){ //Make sure we don't go above max transparency.
      translucency = 255;
    }
    
    fill(0, 0, 0, translucency); //Sets up the rectangle.
    stroke(0, 0, 0, translucency);
    rect(0, 0, w, h); //Draw the fading rectangle.
    
    //If we are at max transparency then show the buttons.
    if(translucency >= 255){
      playAgain.show();
      //endGame.show(); //No, it just causes everything to crash.
    }
    
    noStroke(); //Cleanup because other draw calls don't call this.
    //Then show text for who won.
    if(gameState == endRed){
      fill(255, 0, 0, 255); //Straight red is used to show up on the black background.
      text("Red Wins!", cx, cy);
    }else{
      fill(0, 0, 255, 255); //Straight blue is used to show up on the black background.
      text("Blue Wins!", cx, cy);
    }
    //Updates and renders the fireworks particles.
    leftParts.run();
    rightParts.run();
  }
  
  //Game master set of particles are always drawn because we will allways need them to be available.
  //No real performance loss if they have no particles active.
  gameParticles.run();
  redParticles.run();
  blueParticles.run();
  deathParticles.run();
}

//Check if the player clicks, used for the button.
void mousePressed(){
  if(gameState == endRed || gameState == endBlue){ //The button is only active at the end
    if(playAgain.pressed(mouseX, mouseY)){ //If they are pressing the button.
      //Play again.
      //Clear the player's scores
      for(int i = 0; i < players.size(); i++){
        players.get(i).score = 0;
      }
      //Clean up the end game stuff
      framesSinceEnd = 0;
      gameState = standby;
      
      runCountdown(); //Start a new game.
    }
  }
}

//Stores the value of a key to be pressed so we can check it later.
void keyPressed() {
  if(keyCode ==  32){ //The space bar
    //changeMap(); //Useful for debugging but not for anything else.
  }else{
    keypress.put(Integer.valueOf(keyCode), Boolean.valueOf(true));
  }
}

//Indicates a key has been released so it does not show up later.
void keyReleased(){
  keypress.put(Integer.valueOf(keyCode), Boolean.valueOf(false));  
}

//Play the end particles for the winning team.
void endParticles(int team){
  if(team == pmBlue){
    redParticles = new ParticleSystem(pmRed, 50); //The team mode indicates where the particles will be playing.
  }else if(team == pmRed){
    blueParticles = new ParticleSystem(pmBlue, 50);
  }
}

//Play the death particles at the designated position.
void deathParticles(PVector where){
  deathParticles = new ParticleSystem(where, 100);
}

//Allows checking for keypresses to be asynchronous rither than recieving the event thread in keyPressed/keyReleased.
boolean keyIsDown(int checkKey){
  if(keypress.containsKey(Integer.valueOf(checkKey))){ //Check if the key has been pressed. Otherwise we might get a nullPointerException.
    return keypress.get(Integer.valueOf(checkKey));
  }else{
    return false;
  }
}

//Changes to a random map
void changeMap(){
  int last = current; //Stores our last map so that we can prevent duplication.
  do{
    current = rand.nextInt(4); //Choose a random map.
  }while(last == current); //If we chose the same map as we just had then try agian.
  
  for(int i = 0; i < obstacles.size(); i++){ //Tell all of the obstacles to change modes and move into position for the new map.
    obstacles.get(i).changeMode((byte)current);
  }
}

//Source https://stackoverflow.com/questions/31022269/collision-detection-between-two-rectangles-in-java
//if (RectA.X1 < RectB.X2 && RectA.X2 > RectB.X1 &&
//    RectA.Y1 < RectB.Y2 && RectA.Y2 > RectB.Y1) 
//2d rectangular collision logic
boolean collideRectRect(float x1, float y1, float width1, float height1, float x2, float y2, float width2, float height2){
  if(x1 < x2+width2 && x1+width1 > x2 && y1 < y2+height2 && y1+height1 > y2){
    return true;
  }else{
    return false;
  }
}

//Sets up to run a countdown to game start.
void runCountdown(){
  gameState = standby; //Countdowns must be in standby mode.
  countdownFrames = maxCountdownFrames; //Reset countdown variables to their maximum value.
  framesPerNum = maxFramesPerNum;
  dispNumber = countdownTime;
  changeMap(); //Picks a new map to start this game on.
}