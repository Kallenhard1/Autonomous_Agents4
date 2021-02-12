class Boid {
  PVector Acc;
  PVector Vel;
  PVector Pos;
  float r;
  float maxspeed;
  float maxforce;
  
  Boid(float x, float y) {
    Acc = new PVector(0, 0);
    Vel = new PVector(random(-1,1), random(-1,1));
    Pos = new PVector(x, y);
    r = 3.0;
    maxspeed = 3;
    maxforce = 0.05;
  }
  
  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }
  
  void applyForce(PVector force) {
    Acc.add(force);
  }

  void flock (ArrayList<Boid> boids) {
    PVector sep = separate(boids);
    PVector ali = align(boids);
    PVector coh = cohesion(boids);
    
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }
    
    void update() {
    Vel.add(Acc);
    Vel.limit(maxspeed);
    Pos.add(Vel);
    Acc.mult(0);
  }
  
    PVector seek (PVector target) {
      PVector desired = PVector.sub(target, Pos);
    
      desired.normalize();
      desired.mult(maxspeed);
    
      PVector steer = PVector.sub(desired, Vel);
      steer.limit(maxforce);
      return steer;
  }
  
    void render() {
      float theta = Vel.heading2D() + radians(90);
      fill(175);
      stroke(0);
      pushMatrix();
      translate(Pos.x, Pos.y);
      rotate(theta);
      beginShape(TRIANGLES);
      vertex(0, -r*2);
      vertex(-r, r*2);
      vertex(r, r*2);
      endShape();
      popMatrix();
  }  
  
  void borders() {
    if (Pos.x < -r) Pos.x = width+r;
    if (Pos.y < -r) Pos.y = height+r;
    if (Pos.x > width+r) Pos.x = -r;
    if (Pos.y > height+r) Pos.y = -r;
  }
  
    PVector separate(ArrayList<Boid> boids) {
      float desiredseparation = 25.0f;
      PVector steer = new PVector(0, 0, 0);
      int count = 0;
      
      for(Boid other : boids){
        float d = PVector.dist(Pos, other.Pos);
        if ((d > 0) && (d < desiredseparation)) {
          PVector diff = PVector.sub(Pos, other.Pos);
          diff.normalize();
          diff.div(d);
          steer.add(diff);
          count++;
        }
      }
      if(count > 0) {
        //Take the Avarege speed of the Vehicles.
        steer.div((float)count);
      if(steer.mag() > 0) {
        
        steer.normalize();
        steer.mult(maxspeed);
        //Steer to the Avarege Speed.
        steer.sub(Vel);
        steer.limit(maxforce);
      }
     }
      return steer;
  }
  
  PVector align(ArrayList<Boid> boids) {
    float neighbordist = 50;
      PVector sum = new PVector(0, 0);
      int count = 0;
      for(Boid other : boids){
        float d = PVector.dist(Pos, other.Pos);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(other.Vel);
          count++;
        }
      }
      if(count > 0) {
        //Take the Avarege speed of the Vehicles.
        sum.div((float)count);
        sum.normalize();
        sum.mult(maxspeed);
        PVector steer = PVector.sub(sum, Vel);
        steer.limit(maxforce);
        return steer;
     } else {
      return new PVector(0, 0);
     }
  }
  
  PVector cohesion(ArrayList<Boid> boids) {
      float neighbordist = 50;
      PVector sum = new PVector(0, 0);
      int count = 0;
      for(Boid other : boids){
        float d = PVector.dist(Pos, other.Pos);
        if ((d > 0) && (d < neighbordist)) {
          sum.add(other.Pos);
          count++;
        }
      }
      if(count > 0) {
        //Take the Avarege speed of the Vehicles.
        sum.div((float)count);
        return seek(sum);
     } else {
      return new PVector(0, 0);
     }
  }
  
}
