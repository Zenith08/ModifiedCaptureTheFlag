// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 
//Based on the processing tutorial on particles, falling particles will always have a downward motion even if they go sideways as well.
class FallingParticleSystem {
  ArrayList<FallingParticle> particles; //The initial stuff.
  PVector origin; //Where the particles spawn from.
  color team; //The colour of the particles.

  //Default constructor takes a place to spawn particles and info on which team to spawn the particles for.
  FallingParticleSystem(PVector position, int winner) {
    origin = position.copy();
    particles = new ArrayList<FallingParticle>();
    if(winner == 0){ //Red team is 0, blue team is 1.
      team = color(255, 0, 0);
    }else{
      team = color(0, 0, 255);
    }
  }

  //Adds a particle to the list so that it can be updated.
  void addParticle() {
    particles.add(new FallingParticle(origin, team));
  }

  //Updates the particles and draws them to the screen.
  void run() {
    addParticle(); //Add a particle each frame.
    for (int i = particles.size()-1; i >= 0; i--) {//For each particle
      FallingParticle p = particles.get(i);
      p.run(); //Let it move and draw itself.
      if (p.isDead()) { //If it has existed for its lifespan
        particles.remove(i); //Then we don't need it anymore.
      }
    }
  }
}

// A simple Particle class
//Different than the Particle class found in particles because these go down always.
class FallingParticle {
  //Initial variables to set everything up.
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color team;

  //Default constructor needs a position and colour.
  FallingParticle(PVector l, color winner) {
    acceleration = new PVector(0, 0.05); //Constant acceleration to simulate gravity.
    velocity = new PVector(random(-1, 1), random(-2, 0)); //The y velocity is always negative or sometimes 0. This way it always goes down.
    position = l.copy();
    lifespan = 255.0;
    team = winner;
  }

  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    //Applies acceleration and movement logic and ticks lifespan.
    velocity.add(acceleration);
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    //Setup to draw the circle and then draw it.
    noStroke();
    fill(team);
    ellipse(position.x, position.y, 8, 8);
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) { //If we have exceded our lifespan
      return true; //It isn't useful.
    } else { //Otherwise
      return false; //It is.
    }
  }
}