//Particle modes let us use 1 class for each of the main particles that appear on screen.
final int pmStart = 0;
final int pmRed = 1;
final int pmBlue = 2;
final int pmDeath = 3;
//A generic Particle system scatters in all directions making it different from falling particles. It also only spawns particles once.
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  int partMode; //The mode based on one of the above tells position and colour of the particles.
  //Creates a particle system taking into account what it is intended to be used for and how many particles should spawn.
  //numParticles can be reduced to help performance.
  ParticleSystem(int inPart, int numParticles) {
    if(inPart == pmStart){
      origin = new PVector(w/2, h/2); //The start particles need to be in the centre.
    }else if(inPart == pmRed){
      origin = new PVector(w-50, h/2); //Red particle location
    }else if(inPart == pmBlue){
      origin = new PVector(50, h/2); //Blue particle location.
    }
    //Death particles are handled using the other constructor.
    particles = new ArrayList<Particle>();
    partMode = inPart;
    for(int i = 0; i < numParticles; i++){
      addParticle(inPart); //As long as the particles know what mode they're in the rest will set itself up.
    }
  }
  
  //Death particles can be handled seperatly.
  //Spawns death particles at the needed location defined by start.
  ParticleSystem(PVector start, int numParticles){
    origin = start.copy();
    partMode = pmDeath; //If you need a custom position it has to be death particles.
    particles = new ArrayList<Particle>();
    for(int i = 0; i < numParticles; i++){
      addParticle(pmDeath); //Add the particles in.
    }
  }

  void addParticle(int mode) {
    particles.add(new Particle(origin, mode));
  }

  //Update all existing particles and let them be drawn.
  //Does not add new particles.
  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}


// A simple Particle class
//Particle has been modified so that particles go in any direction not just down.
class Particle {
  PVector position;
  PVector velocity;
  float lifespan;
  int partMode;
  color particleColour;

  Particle(PVector l, int mode) {
    partMode = mode;
    //acceleration = new PVector(0, 0.05);
    if(mode == pmStart){
      velocity = new PVector(random(-1, 1), random(-1, 1)); //Start particles spawn in all directions
      particleColour = color(255, 255, 0); //And are also yellow.
    }else if(mode == pmRed){
      velocity = new PVector(random(-1, 0), random(-1, 1)); //Red losing particles need to go left but can go up or down.
      particleColour = teams[0]; //Gets the colour of the red team
    }else if(mode == pmBlue){
      velocity = new PVector(random(0, 1), random(-1, 1)); //Like red particles but for blue losing.
      particleColour = teams[1]; //Gets blue team colour.
    }else if(mode == pmDeath){
      velocity = new PVector(random(-1, 1), random(-1, 1)); //Death particles can scatter like start particles.
      particleColour = color(255, 255, 255); //They are white.
    }
    
    position = l.copy();
    lifespan = 120.0; //Shorter lifespan speeds up effect.
  }
  
  //Update position and render.
  void run() {
    update();
    display();
  }

  // Method to update position
  void update() {
    position.add(velocity);
    lifespan -= 1.0;
  }

  // Method to display
  void display() {
    float lifeBuf = lifespan;
    stroke(particleColour, (lifeBuf/120) * 255);
    fill(particleColour, (lifeBuf/120)*255);
    ellipse(position.x, position.y, 8, 8);
    noStroke();
  }

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}