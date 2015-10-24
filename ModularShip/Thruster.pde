
class Thruster {
  PVector position;
  PVector force;
  float orientation;
  
  Thruster(PVector position, PVector force) {
    this.position = position;
    this.force = force;
    orientation = 0;
  }
  
  void propel(Ship ship) {
    PVector f = new PVector(force.x, force.y);
    f.rotate(orientation);
    f.rotate(ship.getRotation());
    PVector p = new PVector(position.x, position.y);
    p.rotate(ship.getRotation());
    ship.addForce(f.x, f.y, p.x, p.y);
    
    pushMatrix();
    translate(ship.getX(), ship.getY());
    rotate(ship.getRotation());
    translate(position.x, position.y);
    rotate(orientation);
    fill(170, 0, 0);
    ellipse(0, 0, 15, 25);
    popMatrix();
  }
  
  PVector getForce() {
    PVector f = new PVector(force.x, force.y);
    f.rotate(orientation);
    return f;
  }
}