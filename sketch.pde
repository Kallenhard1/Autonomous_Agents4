Flock flock;

void setup() {
  size(600, 600);
  
  flock = new Flock();
  
  for(int i = 0; i < 200; i++) {
    Boid b = new Boid(width/2, height/2);
    flock.addBoid(b);
  }
  
}

void draw() {
  background(245);
  flock.run();
  
  fill(0);
  //saveFrame("agent1_####.png");
}

void mouseDragged() {
  flock.addBoid(new Boid(mouseX, mouseY));
}
