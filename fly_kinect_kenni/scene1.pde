class Particle {

  PVector location;
  PVector velocity;
  PVector acceleration;
  float strength;

  Particle(PVector loc) {
    location = loc.get();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    strength = 2;
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(20);
    velocity.mult(0.997);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    fill(200);
    ellipse(location.x, location.y, 20, 20);
  }

  PVector calcForce(PVector mouse_, int dir) {
    PVector mouse = mouse_.get();
    PVector force = PVector.sub(mouse, location);
    float distance = force.mag();
    distance = constrain(distance, 5, 40);
    force.normalize();
    force.mult(strength);
    force.mult(dir);

    return force;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }
}



